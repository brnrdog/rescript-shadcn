@xote.component
let make = () =>
  <Field.Group>
    <Field>
      <Field.Label for_="fieldgroup-name"> {"Name"} </Field.Label>
      <Input id="fieldgroup-name" placeholder="Jordan Lee" />
    </Field>
    <Field>
      <Field.Label for_="fieldgroup-email"> {"Email"} </Field.Label>
      <Input id="fieldgroup-email" type_="email" placeholder="name@example.com" />
      <Field.Description> {"We'll send updates to this address."} </Field.Description>
    </Field>
    <Field orientation=Horizontal>
      <Button type_="reset" variant=Outline> {"Reset"} </Button>
      <Button type_="submit"> {"Submit"} </Button>
    </Field>
  </Field.Group>
