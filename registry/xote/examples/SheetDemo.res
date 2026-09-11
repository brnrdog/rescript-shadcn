@xote.component
let make = () =>
  <Sheet>
    <Sheet.Trigger className={Button.buttonVariants(~variant=Outline)}> {"Open"} </Sheet.Trigger>
    <Sheet.Content>
      <Sheet.Header>
        <Sheet.Title> {"Edit profile"} </Sheet.Title>
        <Sheet.Description>
          {"Make changes to your profile here. Click save when you're done."}
        </Sheet.Description>
      </Sheet.Header>
      <div class="grid flex-1 auto-rows-min gap-6 px-4">
        <div class="grid gap-3">
          <Label for_="sheet-demo-name"> {"Name"} </Label>
          <Input id="sheet-demo-name" defaultValue="Pedro Duarte" />
        </div>
        <div class="grid gap-3">
          <Label for_="sheet-demo-username"> {"Username"} </Label>
          <Input id="sheet-demo-username" defaultValue="@peduarte" />
        </div>
      </div>
      <Sheet.Footer>
        <Button type_="submit"> {"Save changes"} </Button>
        <Sheet.Close className={Button.buttonVariants(~variant=Outline)}> {"Close"} </Sheet.Close>
      </Sheet.Footer>
    </Sheet.Content>
  </Sheet>
