@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-6">
    <Item variant=Item.Variant.Outline>
      <Item.Media variant=Item.Media.Variant.Icon>
        <Icons.Inbox />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Default Size"} </Item.Title>
        <Item.Description>
          {"The standard size for most use cases."}
        </Item.Description>
      </Item.Content>
    </Item>
    <Item variant=Item.Variant.Outline size=Item.Size.Sm>
      <Item.Media variant=Item.Media.Variant.Icon>
        <Icons.Inbox />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Small Size"} </Item.Title>
        <Item.Description> {"A compact size for dense layouts."} </Item.Description>
      </Item.Content>
    </Item>
    <Item variant=Item.Variant.Outline size=Item.Size.Xs>
      <Item.Media variant=Item.Media.Variant.Icon>
        <Icons.Inbox />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Extra Small Size"} </Item.Title>
        <Item.Description> {"The most compact size available."} </Item.Description>
      </Item.Content>
    </Item>
  </div>
