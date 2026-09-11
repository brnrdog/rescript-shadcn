@xote.component
let make = () =>
  <Menubar ariaLabel="Main" className="w-72">
    <Menubar.Menu>
      <Menubar.Trigger> {"File"} </Menubar.Trigger>
      <Menubar.Content>
        <Menubar.Item>
          {"New Tab"}
          <Menubar.Shortcut> {"⌘T"} </Menubar.Shortcut>
        </Menubar.Item>
        <Menubar.Item> {"New Window"} </Menubar.Item>
        <Menubar.Separator />
        <Menubar.Item disabled=true> {"Share"} </Menubar.Item>
      </Menubar.Content>
    </Menubar.Menu>
    <Menubar.Menu>
      <Menubar.Trigger> {"Edit"} </Menubar.Trigger>
      <Menubar.Content>
        <Menubar.Item>
          {"Undo"}
          <Menubar.Shortcut> {"⌘Z"} </Menubar.Shortcut>
        </Menubar.Item>
        <Menubar.Item> {"Redo"} </Menubar.Item>
      </Menubar.Content>
    </Menubar.Menu>
  </Menubar>
