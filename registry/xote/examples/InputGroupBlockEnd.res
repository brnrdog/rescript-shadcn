@xote.component
let make = () =>
  <Field.Group className="max-w-sm">
    <Field>
      <Field.Label for_="block-end-input"> {"Input"} </Field.Label>
      <InputGroup className="h-auto">
        <InputGroup.Input id="block-end-input" placeholder="Enter amount" />
        <InputGroup.Addon align=BlockEnd>
          <InputGroup.Text> {"USD"} </InputGroup.Text>
        </InputGroup.Addon>
      </InputGroup>
      <Field.Description> {"Footer positioned below the input."} </Field.Description>
    </Field>
    <Field>
      <Field.Label for_="block-end-textarea"> {"Textarea"} </Field.Label>
      <InputGroup>
        <InputGroup.Textarea id="block-end-textarea" placeholder="Write a comment..." />
        <InputGroup.Addon align=BlockEnd>
          <InputGroup.Text> {"0/280"} </InputGroup.Text>
          <InputGroup.Button variant=Default size=Sm className="ml-auto">
            {"Post"}
          </InputGroup.Button>
        </InputGroup.Addon>
      </InputGroup>
      <Field.Description>
        {"Footer positioned below the textarea."}
      </Field.Description>
    </Field>
  </Field.Group>
