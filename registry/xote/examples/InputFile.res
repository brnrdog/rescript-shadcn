@xote.component
let make = () =>
  <Field>
    <Field.Label for_="picture"> {"Picture"} </Field.Label>
    <Input id="picture" type_="file" />
    <Field.Description> {"Select a picture to upload."} </Field.Description>
  </Field>
