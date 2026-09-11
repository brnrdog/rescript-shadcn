@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* A month grid written against `Date` — react-day-picker, which the React
   registries use, has no framework-agnostic core. */

module Mode = {
  @unboxed
  type t =
    | @as("single") Single
    | @as("multiple") Multiple
    | @as("range") Range
}

module DateRange = {
  type t = {from: Date.t, to: Date.t}
}
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
  ~mode: Mode.t=Single,
  ~selected: option<MaybeSignal.t<option<Date.t>>>=?,
  ~onSelect: option<Date.t => unit>=?,
  ~selectedDates: option<MaybeSignal.t<array<Date.t>>>=?,
  ~onSelectDates: option<array<Date.t> => unit>=?,
  ~selectedRange: option<MaybeSignal.t<option<DateRange.t>>>=?,
  ~onSelectRange: option<option<DateRange.t> => unit>=?,
  ~defaultMonth: option<Date.t>=?,
  ~ariaLabel: string="Calendar",
) => {
  let today = Date.make()
  let month = Signal.make(startOfMonth(defaultMonth->Option.getOr(today)))

  /* Uncontrolled state for each mode, so `<Calendar mode=Range />` is useful on
     its own; a caller that passes the matching prop drives it instead. */
  let ownSingle = Signal.make(None)
  let ownMany = Signal.make([])
  let ownRange = Signal.make(None)

  let currentSingle = () =>
    switch selected {
    | Some(value) => MaybeSignal.get(value)
    | None => Signal.get(ownSingle)
    }

  let currentMany = () =>
    switch selectedDates {
    | Some(value) => MaybeSignal.get(value)
    | None => Signal.get(ownMany)
    }

  let currentRange = () =>
    switch selectedRange {
    | Some(value) => MaybeSignal.get(value)
    | None => Signal.get(ownRange)
    }

  let pick = date =>
    switch mode {
    | Single =>
      if selected === None {
        Signal.set(ownSingle, Some(date))
      }
      switch onSelect {
      | Some(onSelect) => onSelect(date)
      | None => ()
      }
    | Multiple =>
      let current = currentMany()
      let next = current->Array.some(entry => isSameDay(entry, date))
        ? current->Array.filter(entry => !isSameDay(entry, date))
        : Array.concat(current, [date])
      if selectedDates === None {
        Signal.set(ownMany, next)
      }
      switch onSelectDates {
      | Some(onSelectDates) => onSelectDates(next)
      | None => ()
      }
    | Range =>
      /* First click starts a range, second completes it, third starts over. */
      let next = switch currentRange() {
      | Some({from, to}) if isSameDay(from, to) =>
        Date.getTime(date) < Date.getTime(from)
          ? Some({DateRange.from: date, to: from})
          : Some({DateRange.from, to: date})
      | _ => Some({DateRange.from: date, to: date})
      }
      if selectedRange === None {
        Signal.set(ownRange, next)
      }
      switch onSelectRange {
      | Some(onSelectRange) => onSelectRange(next)
      | None => ()
      }
    }

  let isSelected = date =>
    switch mode {
    | Single => currentSingle()->Option.mapOr(false, selected => isSameDay(selected, date))
    | Multiple => currentMany()->Array.some(entry => isSameDay(entry, date))
    | Range =>
      currentRange()->Option.mapOr(false, ({from, to}) =>
        isSameDay(from, date) || isSameDay(to, date)
      )
    }

  let rangePosition = date =>
    switch (mode, currentRange()) {
    | (Range, Some({from, to})) =>
      let time = Date.getTime(date)
      if isSameDay(from, date) {
        Some("start")
      } else if isSameDay(to, date) {
        Some("end")
      } else if time > Date.getTime(from) && time < Date.getTime(to) {
        Some("middle")
      } else {
        None
      }
    | _ => None
    }

  <div
    id=?{id}
    role="group"
    ariaLabel
    class={cn("cn-calendar bg-background p-3", className)}
    attrs=[View.attr("data-slot", "calendar"), View.attr("data-mode", (mode :> string))]>
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
    <div role="grid" class="grid grid-cols-7" attrs=[View.attr("data-slot", "calendar-grid")]>
      <View.For
        each={MaybeSignal.computed(() => monthDays(Signal.get(month)))}
        by={day => day.key}
        render={day =>
          <button
            type_="button"
            class="cn-calendar-day-button flex size-8 items-center justify-center rounded-md text-sm outline-none data-[outside=true]:opacity-40 data-[selected=true]:bg-primary data-[selected=true]:text-primary-foreground data-[range=middle]:bg-accent data-[range=middle]:text-accent-foreground data-[today=true]:font-semibold hover:bg-accent focus-visible:ring-[3px] focus-visible:ring-ring/50"
            onClick={_ => pick(day.date)}
            attrs=[
              View.attr("data-slot", "calendar-day-button"),
              View.attr("data-outside", day.inMonth ? "false" : "true"),
              View.attr("data-today", isSameDay(day.date, today) ? "true" : "false"),
              View.computedAttr("data-selected", () => isSelected(day.date) ? "true" : "false"),
              View.optionalComputedAttr("data-range", () => rangePosition(day.date)),
              View.computedAttr("aria-selected", () => isSelected(day.date) ? "true" : "false"),
            ]>
            {day.date->Date.getDate->Int.toString}
          </button>}
      />
    </div>
  </div>
}
