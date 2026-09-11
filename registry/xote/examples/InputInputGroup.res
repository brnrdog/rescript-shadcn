@xote.component
let make = () =>
  <Field>
    <Field.Label for_="input-group-url"> {"Website URL"} </Field.Label>
    <InputGroup>
      <InputGroup.Input id="input-group-url" placeholder="example.com" />
      <InputGroup.Addon>
        <InputGroup.Text> {"https://"} </InputGroup.Text>
      </InputGroup.Addon>
      <InputGroup.Addon align=InlineEnd>
        <Icons.Info />
      </InputGroup.Addon>
    </InputGroup>
  </Field>
