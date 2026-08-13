/* A drawer on small screens, a dialog once there is room for one. The media
   query is read once and then kept in a signal, so only the matching branch is
   mounted. */
let watchMedia: (string, bool => unit) => unit = %raw(`function (query, report) {
  const list = window.matchMedia(query)
  report(list.matches)
  list.addEventListener("change", (event) => report(event.matches))
}`)

module ProfileForm = {
  @xote.component
  let make = (~className: option<string>=?) =>
    <form class={`grid items-start gap-6 ${className->Option.getOr("")}`}>
      <div class="grid gap-3">
        <Label for_="email"> {"Email"} </Label>
        <Input type_="email" id="email" defaultValue="shadcn@example.com" />
      </div>
      <div class="grid gap-3">
        <Label for_="username"> {"Username"} </Label>
        <Input id="username" defaultValue="@shadcn" />
      </div>
      <Button type_="submit"> {"Save changes"} </Button>
    </form>
}

@xote.component
let make = () => {
  let isDesktop = Signal.make(false)
  watchMedia("(min-width: 768px)", matches => Signal.set(isDesktop, matches))

  <View.Show
    when_={MaybeSignal.reactive(isDesktop)}
    fallback={<Drawer>
      <Drawer.Trigger className={Button.buttonVariants(~variant=Outline)}>
        {"Edit Profile"}
      </Drawer.Trigger>
      <Drawer.Content>
        <Drawer.Header className="text-left">
          <Drawer.Title> {"Edit profile"} </Drawer.Title>
          <Drawer.Description>
            {"Make changes to your profile here. Click save when you're done."}
          </Drawer.Description>
        </Drawer.Header>
        <ProfileForm className="px-4" />
        <Drawer.Footer className="pt-2">
          <Drawer.Close className={Button.buttonVariants(~variant=Outline)}>
            {"Cancel"}
          </Drawer.Close>
        </Drawer.Footer>
      </Drawer.Content>
    </Drawer>}>
    <Dialog>
      <Dialog.Trigger className={Button.buttonVariants(~variant=Outline)}>
        {"Edit Profile"}
      </Dialog.Trigger>
      <Dialog.Content className="sm:max-w-[425px]">
        <Dialog.Header>
          <Dialog.Title> {"Edit profile"} </Dialog.Title>
          <Dialog.Description>
            {"Make changes to your profile here. Click save when you're done."}
          </Dialog.Description>
        </Dialog.Header>
        <ProfileForm />
      </Dialog.Content>
    </Dialog>
  </View.Show>
}
