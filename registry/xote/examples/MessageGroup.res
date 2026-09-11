@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-8">
    <Message.Group>
      <Message>
        <Message.Content>
          <Bubble variant=Muted>
            <Bubble.Content> {"The class hooks match upstream now."} </Bubble.Content>
          </Bubble>
        </Message.Content>
      </Message>
      <Message>
        <Message.Content>
          <Bubble variant=Muted>
            <Bubble.Content> {"I also regenerated the registry."} </Bubble.Content>
          </Bubble>
        </Message.Content>
      </Message>
    </Message.Group>
    <Message align=End>
      <Message.Content>
        <Bubble>
          <Bubble.Content> {"Perfect, update the docs page."} </Bubble.Content>
        </Bubble>
      </Message.Content>
    </Message>
  </div>
