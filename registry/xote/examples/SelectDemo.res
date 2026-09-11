@xote.component
let make = () => {
  let value = Signal.make("")

  <Select
    value={MaybeSignal.reactive(value)}
    onValueChange={next => Signal.set(value, next)}
    placeholder="Select a fruit">
    <Select.Trigger className="w-[180px]" ariaLabel="Fruit">
      <Select.Value />
    </Select.Trigger>
    <Select.Content className="w-[180px]">
      <Select.Label> {"Fruits"} </Select.Label>
      <Select.Item value="apple" label="Apple"> {"Apple"} </Select.Item>
      <Select.Item value="banana" label="Banana"> {"Banana"} </Select.Item>
      <Select.Item value="blueberry" label="Blueberry"> {"Blueberry"} </Select.Item>
      <Select.Separator />
      <Select.Item value="pineapple" label="Pineapple" disabled=true> {"Pineapple"} </Select.Item>
    </Select.Content>
  </Select>
}
