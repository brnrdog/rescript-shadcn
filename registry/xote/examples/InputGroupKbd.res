@xote.component
let make = () =>
  <InputGroup className="max-w-sm">
    <InputGroup.Input placeholder="Search..." />
    <InputGroup.Addon>
      <Icons.Search className="text-muted-foreground" />
    </InputGroup.Addon>
    <InputGroup.Addon align=InlineEnd>
      <Kbd> {"⌘K"} </Kbd>
    </InputGroup.Addon>
  </InputGroup>
