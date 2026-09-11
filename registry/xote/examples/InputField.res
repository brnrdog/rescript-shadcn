@xote.component
let make = () =>
  <Field>
    <Field.Label for_="input-field-username"> {"Username"} </Field.Label>
    <Input id="input-field-username" type_="text" placeholder="Enter your username" />
    <Field.Description>
      {"Choose a unique username for your account."}
    </Field.Description>
  </Field>
