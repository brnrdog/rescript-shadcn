@xote.component
let make = () =>
  <div class="grid w-full max-w-sm gap-4">
    <InputGroup>
      <InputGroup.Input placeholder="Searching..." />
      <InputGroup.Addon align=InlineEnd>
        <Spinner />
      </InputGroup.Addon>
    </InputGroup>
    <InputGroup>
      <InputGroup.Input placeholder="Processing..." />
      <InputGroup.Addon>
        <Spinner />
      </InputGroup.Addon>
    </InputGroup>
    <InputGroup>
      <InputGroup.Input placeholder="Saving changes..." />
      <InputGroup.Addon align=InlineEnd>
        <InputGroup.Text> {"Saving..."} </InputGroup.Text>
        <Spinner />
      </InputGroup.Addon>
    </InputGroup>
    <InputGroup>
      <InputGroup.Input placeholder="Refreshing data..." />
      <InputGroup.Addon>
        <Icons.Loader className="animate-spin" />
      </InputGroup.Addon>
      <InputGroup.Addon align=InlineEnd>
        <InputGroup.Text className="text-muted-foreground">
          {"Please wait..."}
        </InputGroup.Text>
      </InputGroup.Addon>
    </InputGroup>
  </div>
