@xote.component
let make = () =>
  <RadioGroup defaultValue="plus" className="max-w-sm">
    <Field.Label for_="plus-plan">
      <Field orientation=Horizontal>
        <Field.Content>
          <Field.Title> {"Plus"} </Field.Title>
          <Field.Description>
            {"For individuals and small teams."}
          </Field.Description>
        </Field.Content>
        <RadioGroup.Item value="plus" id="plus-plan" />
      </Field>
    </Field.Label>
    <Field.Label for_="pro-plan">
      <Field orientation=Horizontal>
        <Field.Content>
          <Field.Title> {"Pro"} </Field.Title>
          <Field.Description> {"For growing businesses."} </Field.Description>
        </Field.Content>
        <RadioGroup.Item value="pro" id="pro-plan" />
      </Field>
    </Field.Label>
    <Field.Label for_="enterprise-plan">
      <Field orientation=Horizontal>
        <Field.Content>
          <Field.Title> {"Enterprise"} </Field.Title>
          <Field.Description>
            {"For large teams and enterprises."}
          </Field.Description>
        </Field.Content>
        <RadioGroup.Item value="enterprise" id="enterprise-plan" />
      </Field>
    </Field.Label>
  </RadioGroup>
