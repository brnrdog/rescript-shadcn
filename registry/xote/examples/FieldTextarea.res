@xote.component
let make = () =>
  <Field.Set className="w-full max-w-xs">
    <Field.Group>
      <Field>
        <Field.Label for_="feedback"> {"Feedback"} </Field.Label>
        <Textarea id="feedback" placeholder="Your feedback helps us improve..." rows={4} />
        <Field.Description>
          {"Share your thoughts about our service."}
        </Field.Description>
      </Field>
    </Field.Group>
  </Field.Set>
