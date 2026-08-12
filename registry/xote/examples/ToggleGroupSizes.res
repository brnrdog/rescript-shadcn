@xote.component
let make = () =>
  <div class="flex flex-col gap-4">
    <ToggleGroup size=ToggleGroup.Size.Sm defaultValue={["top"]} variant=Outline>
      <ToggleGroup.Item value="top" ariaLabel="Toggle top">
        {"Top"}
      </ToggleGroup.Item>
      <ToggleGroup.Item value="bottom" ariaLabel="Toggle bottom">
        {"Bottom"}
      </ToggleGroup.Item>
      <ToggleGroup.Item value="left" ariaLabel="Toggle left">
        {"Left"}
      </ToggleGroup.Item>
      <ToggleGroup.Item value="right" ariaLabel="Toggle right">
        {"Right"}
      </ToggleGroup.Item>
    </ToggleGroup>
    <ToggleGroup defaultValue={["top"]} variant=Outline>
      <ToggleGroup.Item value="top" ariaLabel="Toggle top">
        {"Top"}
      </ToggleGroup.Item>
      <ToggleGroup.Item value="bottom" ariaLabel="Toggle bottom">
        {"Bottom"}
      </ToggleGroup.Item>
      <ToggleGroup.Item value="left" ariaLabel="Toggle left">
        {"Left"}
      </ToggleGroup.Item>
      <ToggleGroup.Item value="right" ariaLabel="Toggle right">
        {"Right"}
      </ToggleGroup.Item>
    </ToggleGroup>
  </div>
