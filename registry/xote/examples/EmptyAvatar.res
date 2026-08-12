@xote.component
let make = () =>
  <Empty>
    <Empty.Header>
      <Empty.Media variant=Empty.Variant.Default>
        <Avatar className="size-12">
          <Avatar.Image src="https://github.com/shadcn.png" alt="" className="grayscale" />
          <Avatar.Fallback> {"LR"} </Avatar.Fallback>
        </Avatar>
      </Empty.Media>
      <Empty.Title> {"User Offline"} </Empty.Title>
      <Empty.Description>
        {"This user is currently offline. You can leave a message to notify them or try again later."}
      </Empty.Description>
    </Empty.Header>
    <Empty.Content>
      <Button size=Sm> {"Leave Message"} </Button>
    </Empty.Content>
  </Empty>
