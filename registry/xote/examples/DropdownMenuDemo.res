@xote.component
let make = () => {
  let showStatusBar = Signal.make(true)
  let position = Signal.make("bottom")

  <DropdownMenu>
    <DropdownMenu.Trigger className={Button.buttonVariants(~variant=Outline)}>
      {"Open menu"}
    </DropdownMenu.Trigger>
    <DropdownMenu.Content className="w-56">
      <DropdownMenu.Label> {"My Account"} </DropdownMenu.Label>
      <DropdownMenu.Separator />
      <DropdownMenu.Group>
        <DropdownMenu.Item>
          {"Profile"}
          <DropdownMenu.Shortcut> {"⇧⌘P"} </DropdownMenu.Shortcut>
        </DropdownMenu.Item>
        <DropdownMenu.Item>
          {"Billing"}
          <DropdownMenu.Shortcut> {"⌘B"} </DropdownMenu.Shortcut>
        </DropdownMenu.Item>
        <DropdownMenu.Item disabled=true> {"API"} </DropdownMenu.Item>
      </DropdownMenu.Group>
      <DropdownMenu.Separator />
      <DropdownMenu.CheckboxItem
        checked={MaybeSignal.reactive(showStatusBar)}
        onCheckedChange={next => Signal.set(showStatusBar, next)}>
        {"Status bar"}
      </DropdownMenu.CheckboxItem>
      <DropdownMenu.Separator />
      <DropdownMenu.RadioGroup
        value={MaybeSignal.reactive(position)}
        onValueChange={next => Signal.set(position, next)}>
        <DropdownMenu.RadioItem value="top"> {"Top"} </DropdownMenu.RadioItem>
        <DropdownMenu.RadioItem value="bottom"> {"Bottom"} </DropdownMenu.RadioItem>
      </DropdownMenu.RadioGroup>
    </DropdownMenu.Content>
  </DropdownMenu>
}
