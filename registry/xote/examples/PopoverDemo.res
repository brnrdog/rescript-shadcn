@xote.component
let make = () =>
  <Popover>
    <Popover.Trigger className={Button.buttonVariants(~variant=Outline)}>
      {"Open popover"}
    </Popover.Trigger>
    <Popover.Content className="w-80">
      <Popover.Header>
        <Popover.Title> {"Dimensions"} </Popover.Title>
        <Popover.Description> {"Set the dimensions for the layer."} </Popover.Description>
      </Popover.Header>
      <div class="grid gap-2">
        <div class="grid grid-cols-3 items-center gap-4">
          <Label for_="popover-demo-width"> {"Width"} </Label>
          <Input id="popover-demo-width" value={MaybeSignal.static("100%")} className="col-span-2 h-8" />
        </div>
        <div class="grid grid-cols-3 items-center gap-4">
          <Label for_="popover-demo-height"> {"Height"} </Label>
          <Input id="popover-demo-height" value={MaybeSignal.static("25px")} className="col-span-2 h-8" />
        </div>
      </div>
    </Popover.Content>
  </Popover>
