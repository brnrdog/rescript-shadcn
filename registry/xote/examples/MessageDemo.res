@xote.component
let make = () =>
  <Message.Group className="w-full max-w-md gap-4">
    <Message>
      <Message.Avatar>
        <Avatar size=Sm>
          <Avatar.Image src="https://github.com/shadcn.png" alt="@shadcn" />
          <Avatar.Fallback> {"CN"} </Avatar.Fallback>
        </Avatar>
      </Message.Avatar>
      <Message.Content>
        <Message.Header> {"shadcn"} </Message.Header>
        <Bubble>
          <Bubble.Content> {"The registry build is green."} </Bubble.Content>
        </Bubble>
      </Message.Content>
    </Message>
    <Message align=End>
      <Message.Content>
        <Bubble variant=Muted>
          <Bubble.Content> {"Shipping it."} </Bubble.Content>
        </Bubble>
        <Message.Footer> {"Just now"} </Message.Footer>
      </Message.Content>
    </Message>
  </Message.Group>
