@xote.component
let make = () =>
  <Field>
    <Field.Label for_="input-demo-api-key"> {"API Key"} </Field.Label>
    <Input id="input-demo-api-key" type_="password" placeholder="sk-..." />
    <Field.Description>
      {"Your API key is encrypted and stored securely."}
    </Field.Description>
  </Field>
