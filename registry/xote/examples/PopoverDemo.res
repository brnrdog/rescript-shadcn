@xote.component
let make = () =>
  <Popover>
    <Popover.Trigger className={Button.buttonVariants(~variant=Outline)}>
      {"Open popover"}
    </Popover.Trigger>
    <Popover.Content className="w-80">
      <div class="grid gap-4">
        <div class="space-y-2">
          <h4 class="leading-none font-medium"> {"Dimensions"} </h4>
          <p class="text-muted-foreground text-sm">
            {"Set the dimensions for the layer."}
          </p>
        </div>
        <div class="grid gap-2">
          <div class="grid grid-cols-3 items-center gap-4">
            <Label for_="width"> {"Width"} </Label>
            <Input id="width" defaultValue="100%" className="col-span-2 h-8" />
          </div>
          <div class="grid grid-cols-3 items-center gap-4">
            <Label for_="maxWidth"> {"Max. width"} </Label>
            <Input id="maxWidth" defaultValue="300px" className="col-span-2 h-8" />
          </div>
          <div class="grid grid-cols-3 items-center gap-4">
            <Label for_="height"> {"Height"} </Label>
            <Input id="height" defaultValue="25px" className="col-span-2 h-8" />
          </div>
          <div class="grid grid-cols-3 items-center gap-4">
            <Label for_="maxHeight"> {"Max. height"} </Label>
            <Input id="maxHeight" defaultValue="none" className="col-span-2 h-8" />
          </div>
        </div>
      </div>
    </Popover.Content>
  </Popover>
