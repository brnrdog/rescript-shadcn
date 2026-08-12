@xote.component
let make = () =>
  <Dialog>
    <Dialog.Trigger className={Button.buttonVariants(~variant=Outline)}>
      {"Open Dialog"}
    </Dialog.Trigger>
    <Dialog.Content className="sm:max-w-sm">
      <Dialog.Header>
        <Dialog.Title> {"Edit profile"} </Dialog.Title>
        <Dialog.Description>
          {"Make changes to your profile here. Click save when you're done."}
        </Dialog.Description>
      </Dialog.Header>
      <div class="flex flex-col gap-4">
        <div class="grid gap-2">
          <Label for_="dialog-demo-name"> {"Name"} </Label>
          <Input id="dialog-demo-name" name="name" value={MaybeSignal.static("Pedro Duarte")} />
        </div>
        <div class="grid gap-2">
          <Label for_="dialog-demo-username"> {"Username"} </Label>
          <Input id="dialog-demo-username" name="username" value={MaybeSignal.static("@peduarte")} />
        </div>
      </div>
      <Dialog.Footer>
        <Dialog.Close className={Button.buttonVariants(~variant=Outline)}> {"Cancel"} </Dialog.Close>
        <Button type_="submit"> {"Save changes"} </Button>
      </Dialog.Footer>
    </Dialog.Content>
  </Dialog>
