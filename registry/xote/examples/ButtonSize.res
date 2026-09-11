@xote.component
let make = () =>
  <div class="flex flex-col items-start gap-8 sm:flex-row">
    <div class="flex items-start gap-2">
      <Button size=Xs variant=Outline> {"Extra Small"} </Button>
      <Button size=IconXs ariaLabel="Submit" variant=Outline>
        <Icons.ArrowUpRight />
      </Button>
    </div>
    <div class="flex items-start gap-2">
      <Button size=Sm variant=Outline> {"Small"} </Button>
      <Button size=IconSm ariaLabel="Submit" variant=Outline>
        <Icons.ArrowUpRight />
      </Button>
    </div>
    <div class="flex items-start gap-2">
      <Button variant=Outline> {"Default"} </Button>
      <Button size=Icon ariaLabel="Submit" variant=Outline>
        <Icons.ArrowUpRight />
      </Button>
    </div>
    <div class="flex items-start gap-2">
      <Button variant=Outline size=Lg> {"Large"} </Button>
      <Button size=IconLg ariaLabel="Submit" variant=Outline>
        <Icons.ArrowUpRight />
      </Button>
    </div>
  </div>
