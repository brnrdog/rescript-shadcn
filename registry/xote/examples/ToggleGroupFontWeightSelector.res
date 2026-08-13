@xote.component
let make = () => {
  let fontWeight = Signal.make("normal")

  <Field>
    <Field.Label> {"Font Weight"} </Field.Label>
    <ToggleGroup
      defaultValue={["normal"]}
      onValueChange={value =>
        switch value->Array.get(0) {
        | Some(next) => Signal.set(fontWeight, next)
        | None => ()
        }}
      variant=Outline
      spacing=2.
      size=Lg>
      <ToggleGroup.Item
        value="light"
        ariaLabel="Light"
        className="flex size-16 flex-col items-center justify-center rounded-xl">
        <span class="text-2xl leading-none font-light"> {"Aa"} </span>
        <span class="text-muted-foreground text-xs"> {"Light"} </span>
      </ToggleGroup.Item>
      <ToggleGroup.Item
        value="normal"
        ariaLabel="Normal"
        className="flex size-16 flex-col items-center justify-center rounded-xl">
        <span class="text-2xl leading-none font-normal"> {"Aa"} </span>
        <span class="text-muted-foreground text-xs"> {"Normal"} </span>
      </ToggleGroup.Item>
      <ToggleGroup.Item
        value="medium"
        ariaLabel="Medium"
        className="flex size-16 flex-col items-center justify-center rounded-xl">
        <span class="text-2xl leading-none font-medium"> {"Aa"} </span>
        <span class="text-muted-foreground text-xs"> {"Medium"} </span>
      </ToggleGroup.Item>
      <ToggleGroup.Item
        value="bold"
        ariaLabel="Bold"
        className="flex size-16 flex-col items-center justify-center rounded-xl">
        <span class="text-2xl leading-none font-bold"> {"Aa"} </span>
        <span class="text-muted-foreground text-xs"> {"Bold"} </span>
      </ToggleGroup.Item>
    </ToggleGroup>
    <Field.Description>
      {"Use "}
      <code class="bg-muted rounded-md px-1 py-0.5 font-mono">
        {View.signalText(() => `font-${Signal.get(fontWeight)}`)}
      </code>
      {" to set the font weight."}
    </Field.Description>
  </Field>
}
