@xote.component
let make = () =>
  <Field orientation=Horizontal className="w-fit">
    <Field.Label for_="2fa"> {"Multi-factor authentication"} </Field.Label>
    <Switch id="2fa" />
  </Field>
