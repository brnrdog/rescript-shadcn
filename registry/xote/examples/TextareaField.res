@xote.component
let make = () =>
  <Field>
    <Field.Label for_="textarea-message"> {"Message"} </Field.Label>
    <Field.Description> {"Enter your message below."} </Field.Description>
    <Textarea id="textarea-message" placeholder="Type your message here." />
  </Field>
