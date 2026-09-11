@xote.component
let make = () =>
  <Field orientation=Horizontal className="max-w-sm" dataInvalid={true}>
    <Field.Content>
      <Field.Label for_="switch-terms">
        {"Accept terms and conditions"}
      </Field.Label>
      <Field.Description>
        {"You must accept the terms and conditions to continue."}
      </Field.Description>
    </Field.Content>
    <Switch id="switch-terms" ariaInvalid={true} />
  </Field>
