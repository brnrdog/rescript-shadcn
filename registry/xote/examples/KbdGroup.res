@xote.component
let make = () =>
  <div class="flex flex-col items-center gap-4">
    <p class="text-muted-foreground text-sm">
      {"Use "}
      <Kbd.Group>
        <Kbd> {"Ctrl + B"} </Kbd>
        <Kbd> {"Ctrl + K"} </Kbd>
      </Kbd.Group>
      {" to open the command palette"}
    </p>
  </div>
