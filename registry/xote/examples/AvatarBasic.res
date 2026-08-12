@xote.component
let make = () =>
  <Avatar>
    <Avatar.Image src="https://github.com/shadcn.png" alt="@shadcn" className="grayscale" />
    <Avatar.Fallback> {"CN"} </Avatar.Fallback>
  </Avatar>
