@xote.component
let make = () =>
  <Field.Group className="mx-auto w-72">
    <Field orientation=Horizontal>
      <Checkbox id="terms-checkbox-desc" name="terms-checkbox-desc" defaultChecked=true />
      <Field.Content>
        <Field.Label for_="terms-checkbox-desc">
          {"Accept terms and conditions"}
        </Field.Label>
        <Field.Description>
          {"By clicking this checkbox, you agree to the terms and conditions."}
        </Field.Description>
      </Field.Content>
    </Field>
  </Field.Group>
