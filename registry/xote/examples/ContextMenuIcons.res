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
          <Icons.Copy />
          {"Copy"}
        </ContextMenu.Item>
        <ContextMenu.Item>
          <Icons.Scissors />
          {"Cut"}
        </ContextMenu.Item>
        <ContextMenu.Item>
          <Icons.ClipboardPaste />
          {"Paste"}
        </ContextMenu.Item>
      </ContextMenu.Group>
      <ContextMenu.Separator />
      <ContextMenu.Group>
        <ContextMenu.Item variant=ContextMenu.Variant.Destructive>
          <Icons.Trash />
          {"Delete"}
        </ContextMenu.Item>
      </ContextMenu.Group>
    </ContextMenu.Content>
  </ContextMenu>
