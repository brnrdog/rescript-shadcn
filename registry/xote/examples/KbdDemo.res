@xote.component
let make = () =>
  <div class="flex flex-col items-center gap-4">
    <Kbd.Group>
      <Kbd> {"⌘"} </Kbd>
      <Kbd> {"⇧"} </Kbd>
      <Kbd> {"⌥"} </Kbd>
      <Kbd> {"⌃"} </Kbd>
    </Kbd.Group>
    <Kbd.Group>
      <Kbd> {"Ctrl"} </Kbd>
      <span> {"+"} </span>
      <Kbd> {"B"} </Kbd>
    </Kbd.Group>
  </div>
