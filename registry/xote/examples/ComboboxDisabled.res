@xote.component
let make = () =>
  <Combobox>
    <Combobox.Trigger
      disabled=true
      className={Button.buttonVariants(~variant=Outline, ~className="w-[200px]")}>
      {"Select a framework"}
    </Combobox.Trigger>
    <Combobox.Content className="w-[200px] p-0">
      <Combobox.Input placeholder="Search framework..." />
      <Combobox.List>
        <Combobox.Item value="Next.js"> {"Next.js"} </Combobox.Item>
      </Combobox.List>
    </Combobox.Content>
  </Combobox>
