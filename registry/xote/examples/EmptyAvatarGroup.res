@xote.component
let make = () =>
  <Empty>
    <Empty.Header>
      <Empty.Media>
        <div
          class="*:data-[slot=avatar]:ring-background flex -space-x-2 *:data-[slot=avatar]:size-12 *:data-[slot=avatar]:ring-2 *:data-[slot=avatar]:grayscale"
        >
          <Avatar>
            <Avatar.Image src="https://github.com/shadcn.png" alt="@shadcn" />
            <Avatar.Fallback> {"CN"} </Avatar.Fallback>
          </Avatar>
          <Avatar>
            <Avatar.Image src="https://github.com/maxleiter.png" alt="@maxleiter" />
            <Avatar.Fallback> {"LR"} </Avatar.Fallback>
          </Avatar>
          <Avatar>
            <Avatar.Image src="https://github.com/evilrabbit.png" alt="@evilrabbit" />
            <Avatar.Fallback> {"ER"} </Avatar.Fallback>
          </Avatar>
        </div>
      </Empty.Media>
      <Empty.Title> {"No Team Members"} </Empty.Title>
      <Empty.Description>
        {"Invite your team to collaborate on this project."}
      </Empty.Description>
    </Empty.Header>
    <Empty.Content>
      <Button size=Sm>
        <Icons.Plus />
        {"Invite Members"}
      </Button>
    </Empty.Content>
  </Empty>
