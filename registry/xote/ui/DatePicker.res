@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

let formatDate: Date.t => string = %raw(`function (date) {
  return date.toLocaleDateString(undefined, { day: "numeric", month: "long", year: "numeric" })
}`)

/* A calendar in a popover, with the trigger showing the chosen date. */
@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~selected: option<MaybeSignal.t<option<Date.t>>>=?,
  ~onSelect: option<Date.t => unit>=?,
  ~placeholder: string="Pick a date",
  ~ariaLabel: string="Pick a date",
) => {
  let open_ = Signal.make(false)

  let label = () =>
    switch selected {
    | Some(value) => MaybeSignal.get(value)->Option.mapOr(placeholder, formatDate)
    | None => placeholder
    }

  <Popover open_={MaybeSignal.reactive(open_)} onOpenChange={next => Signal.set(open_, next)}>
    <Popover.Trigger
      ?id
      ariaLabel
      className={Button.buttonVariants(
        ~variant=Outline,
        ~className=cn("cn-date-picker-trigger w-[240px] justify-start text-left font-normal", className),
      )}>
      {View.signalText(label)}
    </Popover.Trigger>
    <Popover.Content className="w-auto p-0">
      <Calendar
        ?selected
        onSelect={date => {
          switch onSelect {
          | Some(onSelect) => onSelect(date)
          | None => ()
          }
          Signal.set(open_, false)
        }}
      />
    </Popover.Content>
  </Popover>
}
