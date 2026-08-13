let sides = [
  (ContextMenu.Side.Top, "top"),
  (ContextMenu.Side.Right, "right"),
  (ContextMenu.Side.Bottom, "bottom"),
  (ContextMenu.Side.Left, "left"),
]

@xote.component
let make = () =>
  <div class="grid w-full max-w-sm grid-cols-2 gap-4">
    <View.For
      each={MaybeSignal.static(sides)}
      by={((_, name)) => name}
      render={((side, name)) =>
        <ContextMenu>
          <ContextMenu.Trigger
            className="flex aspect-video w-full max-w-xs items-center justify-center rounded-xl border border-dashed text-sm">
            <span class="hidden pointer-fine:inline-block"> {`Right click (${name})`} </span>
            <span class="hidden pointer-coarse:inline-block"> {`Long press (${name})`} </span>
          </ContextMenu.Trigger>
          <ContextMenu.Content side>
            <ContextMenu.Group>
              <ContextMenu.Item> {"Back"} </ContextMenu.Item>
              <ContextMenu.Item> {"Forward"} </ContextMenu.Item>
              <ContextMenu.Item> {"Reload"} </ContextMenu.Item>
            </ContextMenu.Group>
          </ContextMenu.Content>
        </ContextMenu>}
    />
  </div>
