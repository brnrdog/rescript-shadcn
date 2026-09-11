@xote.component
let make = () =>
  <ContextMenu>
    <ContextMenu.Trigger
      className="flex aspect-video w-full max-w-xs items-center justify-center rounded-xl border border-dashed text-sm"
    >
      <span class="hidden pointer-fine:inline-block"> {"Right click here"} </span>
      <span class="hidden pointer-coarse:inline-block">
        {"Long press here"}
      </span>
    </ContextMenu.Trigger>
    <ContextMenu.Content>
      <ContextMenu.Group>
        <ContextMenu.Label> {"File"} </ContextMenu.Label>
        <ContextMenu.Item>
          {"New File"}
          <ContextMenu.Shortcut> {"\u2318N"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
        <ContextMenu.Item>
          {"Open File"}
          <ContextMenu.Shortcut> {"\u2318O"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
        <ContextMenu.Item>
          {"Save"}
          <ContextMenu.Shortcut> {"\u2318S"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
      </ContextMenu.Group>
      <ContextMenu.Separator />
      <ContextMenu.Group>
        <ContextMenu.Label> {"Edit"} </ContextMenu.Label>
        <ContextMenu.Item>
          {"Undo"}
          <ContextMenu.Shortcut> {"\u2318Z"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
        <ContextMenu.Item>
          {"Redo"}
          <ContextMenu.Shortcut> {"\u21e7\u2318Z"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
      </ContextMenu.Group>
      <ContextMenu.Separator />
      <ContextMenu.Group>
        <ContextMenu.Item>
          {"Cut"}
          <ContextMenu.Shortcut> {"\u2318X"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
        <ContextMenu.Item>
          {"Copy"}
          <ContextMenu.Shortcut> {"\u2318C"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
        <ContextMenu.Item>
          {"Paste"}
          <ContextMenu.Shortcut> {"\u2318V"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
      </ContextMenu.Group>
      <ContextMenu.Separator />
      <ContextMenu.Group>
        <ContextMenu.Item variant=ContextMenu.Variant.Destructive>
          {"Delete"}
          <ContextMenu.Shortcut> {"\u232b"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
      </ContextMenu.Group>
    </ContextMenu.Content>
  </ContextMenu>
