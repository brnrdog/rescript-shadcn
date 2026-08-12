@xote.component
let make = () => {
  let selected = Signal.make(Some(Date.make()))

  <Calendar
    className="rounded-lg border"
    selected={MaybeSignal.reactive(selected)}
    onSelect={date => Signal.set(selected, Some(date))}
  />
}
