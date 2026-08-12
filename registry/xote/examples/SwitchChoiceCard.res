@xote.component
let make = () =>
  <Field.Group className="w-full max-w-sm">
    <Field.Label for_="switch-share">
      <Field orientation=Horizontal>
        <Field.Content>
          <Field.Title> {"Share across devices"} </Field.Title>
          <Field.Description>
            {"Focus is shared across devices, and turns off when you leave the app."}
          </Field.Description>
        </Field.Content>
        <Switch id="switch-share" />
      </Field>
    </Field.Label>
    <Field.Label for_="switch-notifications">
      <Field orientation=Horizontal>
        <Field.Content>
          <Field.Title> {"Enable notifications"} </Field.Title>
          <Field.Description>
            {"Receive notifications when focus mode is enabled or disabled."}
          </Field.Description>
        </Field.Content>
        <Switch id="switch-notifications" defaultChecked={true} />
      </Field>
    </Field.Label>
  </Field.Group>
