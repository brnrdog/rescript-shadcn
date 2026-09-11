@xote.component
let make = () =>
  <Field.Group className="max-w-sm">
    <Field>
      <Field.Label for_="block-start-input"> {"Input"} </Field.Label>
      <InputGroup className="h-auto">
        <InputGroup.Input id="block-start-input" placeholder="Enter your name" />
        <InputGroup.Addon align=BlockStart>
          <InputGroup.Text> {"Full Name"} </InputGroup.Text>
        </InputGroup.Addon>
      </InputGroup>
      <Field.Description> {"Header positioned above the input."} </Field.Description>
    </Field>
    <Field>
      <Field.Label for_="block-start-textarea"> {"Textarea"} </Field.Label>
      <InputGroup>
        <InputGroup.Textarea
          id="block-start-textarea"
          placeholder="console.log('Hello, world!');"
          className="font-mono text-sm"
        />
        <InputGroup.Addon align=BlockStart>
          <Icons.FileCode className="text-muted-foreground" />
          <InputGroup.Text className="font-mono"> {"script.js"} </InputGroup.Text>
          <InputGroup.Button size=IconXs className="ml-auto">
            <Icons.Copy />
            <span class="sr-only"> {"Copy"} </span>
          </InputGroup.Button>
        </InputGroup.Addon>
      </InputGroup>
      <Field.Description>
        {"Header positioned above the textarea."}
      </Field.Description>
    </Field>
  </Field.Group>
