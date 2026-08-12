@xote.component
let make = () =>
  <Item.Group>
    <Item variant=Item.Variant.Muted>
      <Item.Content>
        <Item.Title> {"Item 1"} </Item.Title>
        <Item.Description> {"First item in muted group."} </Item.Description>
      </Item.Content>
      <Item.Actions>
        <Button variant=Outline size=Sm> {"Action"} </Button>
      </Item.Actions>
    </Item>
    <Item variant=Item.Variant.Muted>
      <Item.Content>
        <Item.Title> {"Item 2"} </Item.Title>
        <Item.Description> {"Second item in muted group."} </Item.Description>
      </Item.Content>
      <Item.Actions>
        <Button variant=Outline size=Sm> {"Action"} </Button>
      </Item.Actions>
    </Item>
    <Item variant=Item.Variant.Muted>
      <Item.Content>
        <Item.Title> {"Item 3"} </Item.Title>
        <Item.Description> {"Third item in muted group."} </Item.Description>
      </Item.Content>
      <Item.Actions>
        <Button variant=Outline size=Sm> {"Action"} </Button>
      </Item.Actions>
    </Item>
  </Item.Group>
