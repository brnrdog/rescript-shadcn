@xote.component
let make = () =>
  <InputGroup className="max-w-xs">
    <InputGroup.Input placeholder="Search..." />
    <InputGroup.Addon>
      <Icons.Search />
    </InputGroup.Addon>
    <InputGroup.Addon align=InlineEnd> {"12 results"} </InputGroup.Addon>
  </InputGroup>
