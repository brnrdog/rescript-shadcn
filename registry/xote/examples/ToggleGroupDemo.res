@xote.component
let make = () =>
  <ToggleGroup multiple=true defaultValue=["bold"] variant=Outline ariaLabel="Text formatting">
    <ToggleGroup.Item value="bold" ariaLabel="Bold" variant=Outline> {"B"} </ToggleGroup.Item>
    <ToggleGroup.Item value="italic" ariaLabel="Italic" variant=Outline> {"I"} </ToggleGroup.Item>
    <ToggleGroup.Item value="underline" ariaLabel="Underline" variant=Outline>
      {"U"}
    </ToggleGroup.Item>
  </ToggleGroup>
