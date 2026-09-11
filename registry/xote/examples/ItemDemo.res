@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-6">
    <Item variant=Outline>
      <Item.Content>
        <Item.Title> {"Basic Item"} </Item.Title>
        <Item.Description>
          {"A simple item with title and description."}
        </Item.Description>
      </Item.Content>
      <Item.Actions>
        <Button variant=Outline size=Sm> {"Action"} </Button>
      </Item.Actions>
    </Item>
    <Item variant=Outline size=Sm href="#">
      <Item.Media>
        <Icons.BadgeCheck className="size-5" />
      </Item.Media>
      <Item.Content>
        <Item.Title> {"Your profile has been verified."} </Item.Title>
      </Item.Content>
      <Item.Actions>
        <Icons.ChevronRight className="size-4" />
      </Item.Actions>
    </Item>
  </div>
