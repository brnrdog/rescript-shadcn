@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-8">
    <Message>
      <Message.Content>
        <Message.Header>
          <span class="text-sm font-medium"> {"Rhea"} </span>
        </Message.Header>
        <Bubble variant=Muted>
          <Bubble.Content> {"I pushed the updated registry item."} </Bubble.Content>
        </Bubble>
        <Message.Footer>
          <span class="text-xs text-muted-foreground"> {"2 minutes ago"} </span>
        </Message.Footer>
      </Message.Content>
    </Message>
    <Message align=End>
      <Message.Content>
        <Bubble>
          <Bubble.Content> {"Looks good from here."} </Bubble.Content>
        </Bubble>
        <Message.Footer>
          <Button variant=Ghost size=IconXs ariaLabel="Copy message">
            <Icons.Copy />
          </Button>
        </Message.Footer>
      </Message.Content>
    </Message>
  </div>
