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
        <ContextMenu.Item>
          {"Back"}
          <ContextMenu.Shortcut> {"\u2318["} </ContextMenu.Shortcut>
        </ContextMenu.Item>
        <ContextMenu.Item disabled={true}>
          {"Forward"}
          <ContextMenu.Shortcut> {"\u2318]"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
        <ContextMenu.Item>
          {"Reload"}
          <ContextMenu.Shortcut> {"\u2318R"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
      </ContextMenu.Group>
      <ContextMenu.Separator />
      <ContextMenu.Group>
        <ContextMenu.Item>
          {"Save"}
          <ContextMenu.Shortcut> {"\u2318S"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
        <ContextMenu.Item>
          {"Save As..."}
          <ContextMenu.Shortcut> {"\u21e7\u2318S"} </ContextMenu.Shortcut>
        </ContextMenu.Item>
      </ContextMenu.Group>
    </ContextMenu.Content>
  </ContextMenu>
