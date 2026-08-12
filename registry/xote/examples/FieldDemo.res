@xote.component
let make = () =>
  <Field.Group className="w-full max-w-sm gap-4">
    <Field>
      <Field.Label for_="field-demo-name"> {"Name"} </Field.Label>
      <Input id="field-demo-name" placeholder="Evil Rabbit" />
      <Field.Description> {"This appears on your public profile."} </Field.Description>
    </Field>
    <Field orientation=Horizontal>
      <Checkbox id="field-demo-terms" />
      <Field.Label for_="field-demo-terms"> {"Accept terms and conditions"} </Field.Label>
    </Field>
    <Field invalid=true>
      <Field.Label for_="field-demo-email"> {"Email"} </Field.Label>
      <Input id="field-demo-email" type_="email" placeholder="m@example.com" />
      <Field.Error> {"Enter a valid email address."} </Field.Error>
    </Field>
  </Field.Group>
