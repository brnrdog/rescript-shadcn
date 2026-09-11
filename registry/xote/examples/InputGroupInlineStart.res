@xote.component
let make = () =>
  <Field className="max-w-sm">
    <Field.Label for_="inline-start-input"> {"Input"} </Field.Label>
    <InputGroup>
      <InputGroup.Input id="inline-start-input" placeholder="Search..." />
      <InputGroup.Addon align=InlineStart>
        <Icons.Search className="text-muted-foreground" />
      </InputGroup.Addon>
    </InputGroup>
    <Field.Description> {"Icon positioned at the start."} </Field.Description>
  </Field>
