@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-4">
    <InputGroup>
      <InputGroup.Input placeholder="Send a message..." disabled={true} />
      <InputGroup.Addon align=InlineEnd>
        <Spinner />
      </InputGroup.Addon>
    </InputGroup>
    <InputGroup>
      <InputGroup.Textarea placeholder="Send a message..." disabled={true} />
      <InputGroup.Addon align=BlockEnd>
        <Spinner />
        {"Validating..."}
        <InputGroup.Button className="ml-auto" variant=Default>
          <Icons.ArrowUp />
          <span class="sr-only"> {"Send"} </span>
        </InputGroup.Button>
      </InputGroup.Addon>
    </InputGroup>
  </div>
