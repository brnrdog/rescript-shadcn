@xote.component
let make = () =>
  <Avatar.Group className="grayscale">
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
    <Avatar.GroupCount>
      <Icons.Plus />
    </Avatar.GroupCount>
  </Avatar.Group>
