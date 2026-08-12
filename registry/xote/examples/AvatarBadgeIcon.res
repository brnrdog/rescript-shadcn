@xote.component
let make = () =>
  <Avatar className="grayscale">
    <Avatar.Image src="https://github.com/pranathip.png" alt="@pranathip" />
    <Avatar.Fallback> {"PP"} </Avatar.Fallback>
    <Avatar.Badge>
      <Icons.Plus />
    </Avatar.Badge>
  </Avatar>
