@xote.component
let make = () =>
  <Field.Group className="mx-auto w-56">
    <Field orientation=Horizontal>
      <Checkbox id="terms-checkbox-basic" name="terms-checkbox-basic" />
      <Field.Label for_="terms-checkbox-basic">
        {"Accept terms and conditions"}
      </Field.Label>
    </Field>
  </Field.Group>
