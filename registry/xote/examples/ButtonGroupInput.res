@xote.component
let make = () =>
  <ButtonGroup>
    <Input placeholder="Search..." />
    <Button variant=Outline ariaLabel="Search">
      <Icons.Search />
    </Button>
  </ButtonGroup>
