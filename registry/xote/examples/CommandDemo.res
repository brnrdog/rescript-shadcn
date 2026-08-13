@xote.component
let make = () =>
  <Command className="max-w-sm rounded-lg border">
    <Command.Input placeholder="Type a command or search..." />
    <Command.List>
      <Command.Empty> {"No results found."} </Command.Empty>
      <Command.Group heading="Suggestions">
        <Command.Item>
          <Icons.Calendar />
          <span> {"Calendar"} </span>
        </Command.Item>
        <Command.Item>
          <Icons.Smile />
          <span> {"Search Emoji"} </span>
        </Command.Item>
        <Command.Item disabled={true}>
          <Icons.Calculator />
          <span> {"Calculator"} </span>
        </Command.Item>
      </Command.Group>
      <Command.Separator />
      <Command.Group heading="Settings">
        <Command.Item>
          <Icons.User />
          <span> {"Profile"} </span>
          <Command.Shortcut> {"⌘P"} </Command.Shortcut>
        </Command.Item>
        <Command.Item>
          <Icons.CreditCard />
          <span> {"Billing"} </span>
          <Command.Shortcut> {"⌘B"} </Command.Shortcut>
        </Command.Item>
        <Command.Item>
          <Icons.Settings />
          <span> {"Settings"} </span>
          <Command.Shortcut> {"⌘S"} </Command.Shortcut>
        </Command.Item>
      </Command.Group>
    </Command.List>
  </Command>
