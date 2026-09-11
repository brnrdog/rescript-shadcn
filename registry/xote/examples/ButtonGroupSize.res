@xote.component
let make = () =>
  <div class="flex flex-col items-start gap-8">
    <ButtonGroup>
      <Button variant=Outline size=Sm> {"Small"} </Button>
      <Button variant=Outline size=Sm> {"Button"} </Button>
      <Button variant=Outline size=Sm> {"Group"} </Button>
      <Button variant=Outline size=IconSm>
        <Icons.Plus />
      </Button>
    </ButtonGroup>
    <ButtonGroup>
      <Button variant=Outline> {"Default"} </Button>
      <Button variant=Outline> {"Button"} </Button>
      <Button variant=Outline> {"Group"} </Button>
      <Button variant=Outline size=Icon>
        <Icons.Plus />
      </Button>
    </ButtonGroup>
    <ButtonGroup>
      <Button variant=Outline size=Lg> {"Large"} </Button>
      <Button variant=Outline size=Lg> {"Button"} </Button>
      <Button variant=Outline size=Lg> {"Group"} </Button>
      <Button variant=Outline size=IconLg>
        <Icons.Plus />
      </Button>
    </ButtonGroup>
  </div>
