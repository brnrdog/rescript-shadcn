@xote.component
let make = () =>
  <Field>
    <Field.Label for_="input-required">
      {"Required Field "}
      <span class="text-destructive"> {"*"} </span>
    </Field.Label>
    <Input id="input-required" placeholder="This field is required" required={true} />
    <Field.Description> {"This field must be filled out."} </Field.Description>
  </Field>
