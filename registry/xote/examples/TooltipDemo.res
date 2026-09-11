@xote.component
let make = () =>
  <Tooltip>
    <Tooltip.Trigger className={Button.buttonVariants(~variant=Outline)}> {"Hover"} </Tooltip.Trigger>
    <Tooltip.Content>
      <p> {"Add to library"} </p>
    </Tooltip.Content>
  </Tooltip>
