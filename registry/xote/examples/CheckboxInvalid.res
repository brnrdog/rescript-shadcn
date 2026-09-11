@xote.component
let make = () =>
  <Field.Group className="mx-auto w-56">
    <Field orientation=Horizontal dataInvalid={true}>
      <Checkbox id="terms-checkbox-invalid" name="terms-checkbox-invalid" ariaInvalid={true} />
      <Field.Label for_="terms-checkbox-invalid">
        {"Accept terms and conditions"}
      </Field.Label>
    </Field>
  </Field.Group>
