@xote.component
let make = () =>
  <div class="grid w-full max-w-sm gap-6">
    <InputGroup>
      <InputGroup.Addon>
        <InputGroup.Text> {"$"} </InputGroup.Text>
      </InputGroup.Addon>
      <InputGroup.Input placeholder="0.00" />
      <InputGroup.Addon align=InlineEnd>
        <InputGroup.Text> {"USD"} </InputGroup.Text>
      </InputGroup.Addon>
    </InputGroup>
    <InputGroup>
      <InputGroup.Addon>
        <InputGroup.Text> {"https://"} </InputGroup.Text>
      </InputGroup.Addon>
      <InputGroup.Input placeholder="example.com" className="!pl-0.5" />
      <InputGroup.Addon align=InlineEnd>
        <InputGroup.Text> {".com"} </InputGroup.Text>
      </InputGroup.Addon>
    </InputGroup>
    <InputGroup>
      <InputGroup.Input placeholder="Enter your username" />
      <InputGroup.Addon align=InlineEnd>
        <InputGroup.Text> {"@company.com"} </InputGroup.Text>
      </InputGroup.Addon>
    </InputGroup>
    <InputGroup>
      <InputGroup.Textarea placeholder="Enter your message" />
      <InputGroup.Addon align=BlockEnd>
        <InputGroup.Text className="text-muted-foreground text-xs">
          {"120 characters left"}
        </InputGroup.Text>
      </InputGroup.Addon>
    </InputGroup>
  </div>
