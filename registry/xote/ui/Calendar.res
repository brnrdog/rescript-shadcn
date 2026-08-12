@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* A month grid written against `Date` — react-day-picker, which the React
   registries use, has no framework-agnostic core. */
type day = {
  date: Date.t,
  inMonth: bool,
  key: string,
}

let startOfMonth = (date: Date.t) =>
  Date.makeWithYMD(~year=date->Date.getFullYear, ~month=date->Date.getMonth, ~day=1)

let addMonths = (date: Date.t, count: int) =>
  Date.makeWithYMD(
    ~year=date->Date.getFullYear,
    ~month=date->Date.getMonth + count,
    ~day=1,
  )

let addDays = (date: Date.t, count: int) =>
  Date.makeWithYMD(
    ~year=date->Date.getFullYear,
    ~month=date->Date.getMonth,
    ~day=date->Date.getDate + count,
  )

let isSameDay = (a: Date.t, b: Date.t) =>
  a->Date.getFullYear === b->Date.getFullYear &&
  a->Date.getMonth === b->Date.getMonth &&
  a->Date.getDate === b->Date.getDate

let monthLabel: Date.t => string = %raw(`function (date) {
  return date.toLocaleDateString(undefined, { month: "long", year: "numeric" })
}`)

let weekdayLabels: unit => array<string> = %raw(`function () {
  const formatter = new Intl.DateTimeFormat(undefined, { weekday: "short" })
  return Array.from({ length: 7 }, (_, index) =>
    formatter.format(new Date(Date.UTC(2024, 0, 7 + index))),
  )
}`)

/* Six rows always, so the grid never changes height between months. */
let monthDays = (month: Date.t): array<day> => {
  let first = startOfMonth(month)
  let leading = first->Date.getDay
  let start = addDays(first, -leading)

  Array.fromInitializer(~length=42, index => {
    let date = addDays(start, index)
    {
      date,
      inMonth: date->Date.getMonth === month->Date.getMonth,
      key: `${date->Date.getFullYear->Int.toString}-${date->Date.getMonth->Int.toString}-${date
        ->Date.getDate
        ->Int.toString}`,
    }
  })
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~selected: option<MaybeSignal.t<option<Date.t>>>=?,
  ~onSelect: option<Date.t => unit>=?,
  ~defaultMonth: option<Date.t>=?,
  ~ariaLabel: string="Calendar",
) => {
  let today = Date.make()
  let month = Signal.make(startOfMonth(defaultMonth->Option.getOr(today)))
  let selectedDate = () =>
    switch selected {
    | Some(value) => MaybeSignal.get(value)
    | None => None
    }

  <div
    id=?{id}
    role="group"
    ariaLabel
    class={cn("cn-calendar bg-background p-3", className)}
    attrs=[View.attr("data-slot", "calendar")]>
    <div
      class="cn-calendar-caption flex items-center justify-between pb-2"
      attrs=[View.attr("data-slot", "calendar-caption")]>
      <Button
        variant=Outline
        size=IconSm
        ariaLabel="Previous month"
        onClick={_ => Signal.set(month, addMonths(Signal.get(month), -1))}>
        <Icons.ChevronLeft />
      </Button>
      <div
        class="cn-calendar-caption-label text-sm font-medium"
        attrs=[View.attr("data-slot", "calendar-caption-label"), View.attr("aria-live", "polite")]>
        {View.signalText(() => monthLabel(Signal.get(month)))}
      </div>
      <Button
        variant=Outline
        size=IconSm
        ariaLabel="Next month"
        onClick={_ => Signal.set(month, addMonths(Signal.get(month), 1))}>
        <Icons.ChevronRight />
      </Button>
    </div>
    <div class="grid grid-cols-7" attrs=[View.attr("data-slot", "calendar-weekdays")]>
      <View.For
        each={MaybeSignal.static(weekdayLabels())}
        by={label => label}
        render={label =>
          <div class="text-muted-foreground flex h-8 items-center justify-center text-xs">
            {label}
          </div>}
      />
    </div>
    <div
      role="grid"
      class="grid grid-cols-7"
      attrs=[View.attr("data-slot", "calendar-grid")]>
      <View.For
        each={MaybeSignal.computed(() => monthDays(Signal.get(month)))}
        by={day => day.key}
        render={day =>
          <button
            type_="button"
            class="cn-calendar-day-button flex size-8 items-center justify-center rounded-md text-sm outline-none data-[outside=true]:opacity-40 data-[selected=true]:bg-primary data-[selected=true]:text-primary-foreground data-[today=true]:font-semibold hover:bg-accent focus-visible:ring-[3px] focus-visible:ring-ring/50"
            onClick={_ =>
              switch onSelect {
              | Some(onSelect) => onSelect(day.date)
              | None => ()
              }}
            attrs=[
              View.attr("data-slot", "calendar-day-button"),
              View.attr("data-outside", day.inMonth ? "false" : "true"),
              View.attr("data-today", isSameDay(day.date, today) ? "true" : "false"),
              View.computedAttr("data-selected", () =>
                selectedDate()->Option.mapOr(false, date => isSameDay(date, day.date))
                  ? "true"
                  : "false"
              ),
              View.computedAttr("aria-selected", () =>
                selectedDate()->Option.mapOr(false, date => isSameDay(date, day.date))
                  ? "true"
                  : "false"
              ),
            ]>
            {day.date->Date.getDate->Int.toString}
          </button>}
      />
    </div>
  </div>
}
