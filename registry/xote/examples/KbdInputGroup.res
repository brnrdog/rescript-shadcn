@xote.component
let make = () =>
  <div class="flex w-full max-w-xs flex-col gap-6">
    <InputGroup>
      <InputGroup.Input placeholder="Search..." />
      <InputGroup.Addon>
        <Icons.Search />
      </InputGroup.Addon>
      <InputGroup.Addon align=InlineEnd>
        <Kbd> {"⌘"} </Kbd>
        <Kbd> {"K"} </Kbd>
      </InputGroup.Addon>
    </InputGroup>
  </div>
