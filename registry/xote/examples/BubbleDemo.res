@xote.component
let make = () =>
  <Bubble.Group className="w-full max-w-md gap-2">
    <Bubble>
      <Bubble.Content> {"Hey, are we still on for tomorrow?"} </Bubble.Content>
    </Bubble>
    <Bubble variant=Muted align=End className="self-end">
      <Bubble.Content> {"Yes — 10am works."} </Bubble.Content>
    </Bubble>
  </Bubble.Group>
