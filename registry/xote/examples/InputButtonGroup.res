@xote.component
let make = () =>
  <Field>
    <Field.Label for_="input-button-group"> {"Search"} </Field.Label>
    <ButtonGroup>
      <Input id="input-button-group" placeholder="Type to search..." />
      <Button variant=Outline> {"Search"} </Button>
    </ButtonGroup>
  </Field>
