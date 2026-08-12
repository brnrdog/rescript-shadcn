@xote.component
let make = () =>
  <div class="flex flex-wrap items-center gap-2">
    <Tooltip>
      <Tooltip.Trigger className={Button.buttonVariants(~variant=Outline)}>
        {"Hover me"}
      </Tooltip.Trigger>
      <Tooltip.Content> {"Add to library"} </Tooltip.Content>
    </Tooltip>
    <Tooltip>
      <Tooltip.Trigger className={Button.buttonVariants(~variant=Outline)}>
        {"Right"}
      </Tooltip.Trigger>
      <Tooltip.Content side=Right> {"Shown on the right"} </Tooltip.Content>
    </Tooltip>
  </div>
