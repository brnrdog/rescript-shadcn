@xote.component
let make = () =>
  <Dialog>
    <form>
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
        <Field.Group>
          <Field>
            <Label for_="name-1"> {"Name"} </Label>
            <Input id="name-1" name="name" defaultValue="Pedro Duarte" />
          </Field>
          <Field>
            <Label for_="username-1"> {"Username"} </Label>
            <Input id="username-1" name="username" defaultValue="@peduarte" />
          </Field>
        </Field.Group>
        <Dialog.Footer>
          <Dialog.Close className={Button.buttonVariants(~variant=Outline)}>
            {"Cancel"}
          </Dialog.Close>
          <Button type_="submit"> {"Save changes"} </Button>
        </Dialog.Footer>
      </Dialog.Content>
    </form>
  </Dialog>
