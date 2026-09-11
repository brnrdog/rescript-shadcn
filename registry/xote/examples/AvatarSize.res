@xote.component
let make = () =>
  <div class="flex flex-wrap items-center gap-2 grayscale">
    <Avatar size=Sm>
      <Avatar.Image src="https://github.com/shadcn.png" alt="@shadcn" />
      <Avatar.Fallback> {"CN"} </Avatar.Fallback>
    </Avatar>
    <Avatar>
      <Avatar.Image src="https://github.com/shadcn.png" alt="@shadcn" />
      <Avatar.Fallback> {"CN"} </Avatar.Fallback>
    </Avatar>
    <Avatar size=Lg>
      <Avatar.Image src="https://github.com/shadcn.png" alt="@shadcn" />
      <Avatar.Fallback> {"CN"} </Avatar.Fallback>
    </Avatar>
  </div>
