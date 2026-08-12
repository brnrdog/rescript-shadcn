@xote.component
let make = () =>
  <RadioGroup defaultValue="comfortable" className="w-fit">
    <Field orientation=Horizontal>
      <RadioGroup.Item value="default" id="desc-r1" />
      <Field.Content>
        <Field.Label for_="desc-r1"> {"Default"} </Field.Label>
        <Field.Description>
          {"Standard spacing for most use cases."}
        </Field.Description>
      </Field.Content>
    </Field>
    <Field orientation=Horizontal>
      <RadioGroup.Item value="comfortable" id="desc-r2" />
      <Field.Content>
        <Field.Label for_="desc-r2"> {"Comfortable"} </Field.Label>
        <Field.Description> {"More space between elements."} </Field.Description>
      </Field.Content>
    </Field>
    <Field orientation=Horizontal>
      <RadioGroup.Item value="compact" id="desc-r3" />
      <Field.Content>
        <Field.Label for_="desc-r3"> {"Compact"} </Field.Label>
        <Field.Description>
          {"Minimal spacing for dense layouts."}
        </Field.Description>
      </Field.Content>
    </Field>
  </RadioGroup>
