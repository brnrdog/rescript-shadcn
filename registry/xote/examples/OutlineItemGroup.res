@xote.component
let make = () =>
  <Item.Group>
    <Item variant=Item.Variant.Outline>
      <Item.Media variant=Item.Media.Variant.Icon>
        <Icons.Inbox />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Item 1"} </Item.Title>
        <Item.Description> {"First item with icon."} </Item.Description>
      </Item.Content>
    </Item>
    <Item variant=Item.Variant.Outline>
      <Item.Media variant=Item.Media.Variant.Icon>
        <Icons.Inbox />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Item 2"} </Item.Title>
        <Item.Description> {"Second item with icon."} </Item.Description>
      </Item.Content>
    </Item>
    <Item variant=Item.Variant.Outline>
      <Item.Media variant=Item.Media.Variant.Icon>
        <Icons.Inbox />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Item 3"} </Item.Title>
        <Item.Description> {"Third item with icon."} </Item.Description>
      </Item.Content>
    </Item>
  </Item.Group>
