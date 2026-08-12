@xote.component
let make = () =>
  <div class="flex flex-wrap gap-2">
    <Badge> {"Default"} </Badge>
    <Badge variant=Secondary> {"Secondary"} </Badge>
    <Badge variant=Destructive> {"Destructive"} </Badge>
    <Badge variant=Outline> {"Outline"} </Badge>
    <Badge variant=Ghost> {"Ghost"} </Badge>
  </div>
