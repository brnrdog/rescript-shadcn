@xote.component
let make = () =>
  <div class="flex w-full max-w-lg flex-col gap-6">
    <Item variant=Item.Variant.Outline>
      <Item.Media variant=Item.Media.Variant.Icon>
        <Icons.ShieldAlert />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Security Alert"} </Item.Title>
        <Item.Description>
          {"New login detected from unknown device."}
        </Item.Description>
      </Item.Content>
      <Item.Actions>
        <Button size=Sm variant=Outline> {"Review"} </Button>
      </Item.Actions>
    </Item>
  </div>
