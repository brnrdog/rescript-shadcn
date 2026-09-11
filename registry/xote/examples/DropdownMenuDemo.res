@xote.component
let make = () =>
  <DropdownMenu>
    <DropdownMenu.Trigger className={Button.buttonVariants(~variant=Outline)}>
      {"Open"}
    </DropdownMenu.Trigger>
    <DropdownMenu.Content className="w-40" align=Start>
      <DropdownMenu.Group>
        <DropdownMenu.Label> {"My Account"} </DropdownMenu.Label>
        <DropdownMenu.Item>
          {"Profile"}
          <DropdownMenu.Shortcut> {"⇧⌘P"} </DropdownMenu.Shortcut>
        </DropdownMenu.Item>
        <DropdownMenu.Item>
          {"Billing"}
          <DropdownMenu.Shortcut> {"⌘B"} </DropdownMenu.Shortcut>
        </DropdownMenu.Item>
        <DropdownMenu.Item>
          {"Settings"}
          <DropdownMenu.Shortcut> {"⌘S"} </DropdownMenu.Shortcut>
        </DropdownMenu.Item>
      </DropdownMenu.Group>
      <DropdownMenu.Separator />
      <DropdownMenu.Group>
        <DropdownMenu.Item> {"Team"} </DropdownMenu.Item>
        <DropdownMenu.Sub>
          <DropdownMenu.SubTrigger> {"Invite users"} </DropdownMenu.SubTrigger>
          <DropdownMenu.Portal>
            <DropdownMenu.SubContent>
              <DropdownMenu.Item> {"Email"} </DropdownMenu.Item>
              <DropdownMenu.Item> {"Message"} </DropdownMenu.Item>
              <DropdownMenu.Separator />
              <DropdownMenu.Item> {"More..."} </DropdownMenu.Item>
            </DropdownMenu.SubContent>
          </DropdownMenu.Portal>
        </DropdownMenu.Sub>
        <DropdownMenu.Item>
          {"New Team"}
          <DropdownMenu.Shortcut> {"⌘+T"} </DropdownMenu.Shortcut>
        </DropdownMenu.Item>
      </DropdownMenu.Group>
      <DropdownMenu.Separator />
      <DropdownMenu.Group>
        <DropdownMenu.Item> {"GitHub"} </DropdownMenu.Item>
        <DropdownMenu.Item> {"Support"} </DropdownMenu.Item>
        <DropdownMenu.Item disabled=true> {"API"} </DropdownMenu.Item>
      </DropdownMenu.Group>
      <DropdownMenu.Separator />
      <DropdownMenu.Group>
        <DropdownMenu.Item>
          {"Log out"}
          <DropdownMenu.Shortcut> {"⇧⌘Q"} </DropdownMenu.Shortcut>
        </DropdownMenu.Item>
      </DropdownMenu.Group>
    </DropdownMenu.Content>
  </DropdownMenu>
