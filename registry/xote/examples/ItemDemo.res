@xote.component
let make = () =>
  <Item.Group className="flex w-full max-w-md flex-col gap-6">
    <Item variant=Outline>
      <Item.Media variant=Icon>
        <Icons.Check />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Deployment complete"} </Item.Title>
        <Item.Description> {"Your project is live at example.com."} </Item.Description>
      </Item.Content>
      <Item.Actions>
        <Button variant=Outline size=Sm> {"View"} </Button>
      </Item.Actions>
    </Item>
    <Item variant=Muted>
      <Item.Media variant=Icon>
        <Icons.Loader className="animate-spin" />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Build running"} </Item.Title>
        <Item.Description> {"Started a few seconds ago."} </Item.Description>
      </Item.Content>
    </Item>
  </Item.Group>
