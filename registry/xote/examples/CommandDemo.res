@xote.component
let make = () =>
  <Command className="w-full max-w-sm rounded-lg border shadow-md" ariaLabel="Command palette">
    <Command.Input placeholder="Type a command or search..." />
    <Command.List>
      <Command.Empty> {"No results found."} </Command.Empty>
      <Command.Group heading="Suggestions">
        <Command.Item value="Calendar"> {"Calendar"} </Command.Item>
        <Command.Item value="Search Emoji"> {"Search Emoji"} </Command.Item>
        <Command.Item value="Calculator"> {"Calculator"} </Command.Item>
      </Command.Group>
      <Command.Separator />
      <Command.Group heading="Settings">
        <Command.Item value="Profile">
          {"Profile"}
          <Command.Shortcut> {"⌘P"} </Command.Shortcut>
        </Command.Item>
        <Command.Item value="Billing">
          {"Billing"}
          <Command.Shortcut> {"⌘B"} </Command.Shortcut>
        </Command.Item>
      </Command.Group>
    </Command.List>
  </Command>
