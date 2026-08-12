@xote.component
let make = () =>
  <div class="flex w-full max-w-sm flex-col gap-4">
    <InputGroup>
      <InputGroup.Addon>
        <Icons.Search />
      </InputGroup.Addon>
      <InputGroup.Input placeholder="Search components..." />
    </InputGroup>
    <InputGroup>
      <InputGroup.Input placeholder="Type a message" />
      <InputGroup.Addon align=InlineEnd>
        <InputGroup.Button ariaLabel="Send"> {"Send"} </InputGroup.Button>
      </InputGroup.Addon>
    </InputGroup>
  </div>
