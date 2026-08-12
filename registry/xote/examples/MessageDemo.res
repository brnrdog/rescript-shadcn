@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-8">
    <Message align=End>
      <Message.Content>
        <Bubble>
          <Bubble.Content> {"Deploying to prod real quick."} </Bubble.Content>
        </Bubble>
      </Message.Content>
    </Message>
    <Message>
      <Message.Content>
        <Bubble variant=Muted>
          <Bubble.Content> {"It's 4:55 PM. On a Friday."} </Bubble.Content>
        </Bubble>
      </Message.Content>
    </Message>
    <Message align=End>
      <Message.Content>
        <Bubble>
          <Bubble.Content> {"It's a one-line change."} </Bubble.Content>
        </Bubble>
      </Message.Content>
    </Message>
  </div>
