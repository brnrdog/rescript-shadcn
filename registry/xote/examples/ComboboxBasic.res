let frameworks = ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]

@xote.component
let make = () => {
  let selected = Signal.make("")

  <Combobox>
    <Combobox.Trigger className={Button.buttonVariants(~variant=Outline, ~className="w-[200px]")}>
      {View.signalText(() => {
        let value = Signal.get(selected)
        value === "" ? "Select a framework" : value
      })}
    </Combobox.Trigger>
    <Combobox.Content className="w-[200px] p-0">
      <Combobox.Input placeholder="Search framework..." />
      <Combobox.List>
        <Combobox.Empty> {"No items found."} </Combobox.Empty>
        <View.For
          each={MaybeSignal.static(frameworks)}
          by={framework => framework}
          render={framework =>
            <Combobox.Item value={framework} onSelect={() => Signal.set(selected, framework)}>
              {framework}
            </Combobox.Item>}
        />
      </Combobox.List>
    </Combobox.Content>
  </Combobox>
}
