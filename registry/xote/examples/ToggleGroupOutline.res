@xote.component
let make = () =>
  <ToggleGroup variant=Outline defaultValue={["all"]}>
    <ToggleGroup.Item value="all" ariaLabel="Toggle all"> {"All"} </ToggleGroup.Item>
    <ToggleGroup.Item value="missed" ariaLabel="Toggle missed">
      {"Missed"}
    </ToggleGroup.Item>
  </ToggleGroup>
