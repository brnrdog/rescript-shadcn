@xote.component
let make = () =>
  <Field.Group className="w-full max-w-xs">
    <Field.Set>
      <Field.Label> {"Responses"} </Field.Label>
      <Field.Description>
        {"Get notified when ChatGPT responds to requests that take time, like research or image generation."}
      </Field.Description>
      <Field.Group dataSlot="checkbox-group">
        <Field orientation=Horizontal>
          <Checkbox id="push" defaultChecked={true} disabled={true} />
          <Field.Label for_="push" className="font-normal">
            {"Push notifications"}
          </Field.Label>
        </Field>
      </Field.Group>
    </Field.Set>
    <Field.Separator />
    <Field.Set>
      <Field.Label> {"Tasks"} </Field.Label>
      <Field.Description>
        {"Get notified when tasks you've created have updates. "}
        <a href="#"> {"Manage tasks"} </a>
      </Field.Description>
      <Field.Group dataSlot="checkbox-group">
        <Field orientation=Horizontal>
          <Checkbox id="push-tasks" />
          <Field.Label for_="push-tasks" className="font-normal">
            {"Push notifications"}
          </Field.Label>
        </Field>
        <Field orientation=Horizontal>
          <Checkbox id="email-tasks" />
          <Field.Label for_="email-tasks" className="font-normal">
            {"Email notifications"}
          </Field.Label>
        </Field>
      </Field.Group>
    </Field.Set>
  </Field.Group>
