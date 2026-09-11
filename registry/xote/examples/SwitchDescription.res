@xote.component
let make = () =>
  <Field orientation=Horizontal className="max-w-sm">
    <Field.Content>
      <Field.Label for_="switch-focus-mode">
        {"Share across devices"}
      </Field.Label>
      <Field.Description>
        {"Focus is shared across devices, and turns off when you leave the app."}
      </Field.Description>
    </Field.Content>
    <Switch id="switch-focus-mode" />
  </Field>
