@xote.component
let make = () =>
  <Empty className="w-full">
    <Empty.Header>
      <Empty.Media variant=Empty.Variant.Icon>
        <Spinner />
      </Empty.Media>
      <Empty.Title> {"Processing your request"} </Empty.Title>
      <Empty.Description>
        {"Please wait while we process your request. Do not refresh the page."}
      </Empty.Description>
    </Empty.Header>
    <Empty.Content>
      <Button variant=Outline size=Sm> {"Cancel"} </Button>
    </Empty.Content>
  </Empty>
