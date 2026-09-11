@xote.component
let make = () =>
  <div class="flex flex-wrap items-center gap-2 md:flex-row">
    <Button variant=Outline> {"Button"} </Button>
    <Button variant=Outline size=Icon ariaLabel="Submit">
      <Icons.ArrowUp />
    </Button>
  </div>
