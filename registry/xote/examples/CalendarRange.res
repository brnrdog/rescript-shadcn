@xote.component
let make = () => {
  let year = Date.make()->Date.getFullYear
  let range = Signal.make(
    Some({
      Calendar.DateRange.from: Date.makeWithYMD(~year, ~month=0, ~day=12),
      to: Date.makeWithYMD(~year, ~month=0, ~day=20),
    }),
  )

  <Calendar
    mode=Range
    className="rounded-lg border"
    defaultMonth={Date.makeWithYMD(~year, ~month=0, ~day=1)}
    selectedRange={MaybeSignal.reactive(range)}
    onSelectRange={next => Signal.set(range, next)}
  />
}
