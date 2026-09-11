@xote.component
let make = () =>
  <div class="flex gap-2">
    <Button className="rounded-full"> {"Get Started"} </Button>
    <Button variant=Outline size=Icon className="rounded-full">
      <Icons.ArrowUp />
    </Button>
  </div>
