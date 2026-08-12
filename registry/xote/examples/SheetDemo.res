@xote.component
let make = () =>
  <Sheet>
    <Sheet.Trigger className={Button.buttonVariants(~variant=Outline)}> {"Open Sheet"} </Sheet.Trigger>
    <Sheet.Content className="p-4">
      <Sheet.Header>
        <Sheet.Title> {"Edit profile"} </Sheet.Title>
        <Sheet.Description>
          {"Make changes to your profile here. Click save when you're done."}
        </Sheet.Description>
      </Sheet.Header>
      <div class="flex flex-col gap-4">
        <div class="grid gap-2">
          <Label for_="sheet-demo-name"> {"Name"} </Label>
          <Input id="sheet-demo-name" value={MaybeSignal.static("Pedro Duarte")} />
        </div>
        <div class="grid gap-2">
          <Label for_="sheet-demo-username"> {"Username"} </Label>
          <Input id="sheet-demo-username" value={MaybeSignal.static("@peduarte")} />
        </div>
      </div>
      <Sheet.Footer>
        <Button> {"Save changes"} </Button>
        <Sheet.Close className={Button.buttonVariants(~variant=Outline)}> {"Close"} </Sheet.Close>
      </Sheet.Footer>
    </Sheet.Content>
  </Sheet>
