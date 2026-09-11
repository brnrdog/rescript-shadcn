@xote.component
let make = () =>
  <Field.Group className="grid max-w-sm grid-cols-2">
    <Field>
      <Field.Label for_="first-name"> {"First Name"} </Field.Label>
      <Input id="first-name" placeholder="Jordan" />
    </Field>
    <Field>
      <Field.Label for_="last-name"> {"Last Name"} </Field.Label>
      <Input id="last-name" placeholder="Lee" />
    </Field>
  </Field.Group>
