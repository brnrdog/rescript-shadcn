@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-8">
    <Bubble.Group>
      <Bubble variant=Muted>
        <Bubble.Content> {"I finished the audit pass."} </Bubble.Content>
      </Bubble>
      <Bubble variant=Muted>
        <Bubble.Content> {"The registry output is clean now."} </Bubble.Content>
      </Bubble>
    </Bubble.Group>
    <Bubble.Group>
      <Bubble align=End>
        <Bubble.Content> {"Great, ship that patch."} </Bubble.Content>
      </Bubble>
      <Bubble align=End>
        <Bubble.Content> {"Then update the docs."} </Bubble.Content>
      </Bubble>
    </Bubble.Group>
  </div>
