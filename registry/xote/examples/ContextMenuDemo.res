@xote.component
let make = () => {
  let showBookmarks = Signal.make(true)

  <ContextMenu>
    <ContextMenu.Trigger className="flex h-[150px] w-[300px] items-center justify-center rounded-md border border-dashed text-sm">
      {"Right click here"}
    </ContextMenu.Trigger>
    <ContextMenu.Content className="w-52">
      <ContextMenu.Item>
        {"Back"}
        <ContextMenu.Shortcut> {"⌘["} </ContextMenu.Shortcut>
      </ContextMenu.Item>
      <ContextMenu.Item disabled=true> {"Forward"} </ContextMenu.Item>
      <ContextMenu.Separator />
      <ContextMenu.CheckboxItem
        checked={MaybeSignal.reactive(showBookmarks)}
        onCheckedChange={next => Signal.set(showBookmarks, next)}>
        {"Show bookmarks"}
      </ContextMenu.CheckboxItem>
    </ContextMenu.Content>
  </ContextMenu>
}
