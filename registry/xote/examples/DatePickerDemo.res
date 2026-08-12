@xote.component
let make = () => {
  let selected = Signal.make(None)

  <DatePicker
    selected={MaybeSignal.reactive(selected)}
    onSelect={date => Signal.set(selected, Some(date))}
  />
}
