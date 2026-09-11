@xote.component
let make = () =>
  <Menubar className="w-72">
    <Menubar.Menu>
      <Menubar.Trigger> {"File"} </Menubar.Trigger>
      <Menubar.Content>
        <Menubar.Item>
          <Icons.File />
          {"New File"}
          <Menubar.Shortcut> {"⌘N"} </Menubar.Shortcut>
        </Menubar.Item>
        <Menubar.Item>
          <Icons.Folder />
          {"Open Folder"}
        </Menubar.Item>
        <Menubar.Separator />
        <Menubar.Item>
          <Icons.Save />
          {"Save"}
          <Menubar.Shortcut> {"⌘S"} </Menubar.Shortcut>
        </Menubar.Item>
      </Menubar.Content>
    </Menubar.Menu>
    <Menubar.Menu>
      <Menubar.Trigger> {"More"} </Menubar.Trigger>
      <Menubar.Content>
        <Menubar.Group>
          <Menubar.Item>
            <Icons.Settings />
            {"Settings"}
          </Menubar.Item>
          <Menubar.Item>
            <Icons.HelpCircle />
            {"Help"}
          </Menubar.Item>
          <Menubar.Separator />
          <Menubar.Item variant=Destructive>
            <Icons.Trash />
            {"Delete"}
          </Menubar.Item>
        </Menubar.Group>
      </Menubar.Content>
    </Menubar.Menu>
  </Menubar>
