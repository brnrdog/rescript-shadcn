@xote.component
let make = () =>
  <Field className="max-w-sm">
    <Field.Label for_="inline-end-input"> {"Input"} </Field.Label>
    <InputGroup>
      <InputGroup.Input id="inline-end-input" type_="password" placeholder="Enter password" />
      <InputGroup.Addon align=InlineEnd>
        <Icons.EyeOff />
      </InputGroup.Addon>
    </InputGroup>
    <Field.Description> {"Icon positioned at the end."} </Field.Description>
  </Field>
