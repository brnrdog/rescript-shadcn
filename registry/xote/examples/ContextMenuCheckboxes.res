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
        <ContextMenu.CheckboxItem defaultChecked={true}>
          {"Show Bookmarks Bar"}
        </ContextMenu.CheckboxItem>
        <ContextMenu.CheckboxItem> {"Show Full URLs"} </ContextMenu.CheckboxItem>
        <ContextMenu.CheckboxItem defaultChecked={true}>
          {"Show Developer Tools"}
        </ContextMenu.CheckboxItem>
      </ContextMenu.Group>
    </ContextMenu.Content>
  </ContextMenu>
