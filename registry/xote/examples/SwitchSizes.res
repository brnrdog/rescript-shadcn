@xote.component
let make = () =>
  <Field.Group className="w-full max-w-[10rem]">
    <Field orientation=Horizontal>
      <Switch id="switch-size-sm" size=Switch.Size.Sm />
      <Field.Label for_="switch-size-sm"> {"Small"} </Field.Label>
    </Field>
    <Field orientation=Horizontal>
      <Switch id="switch-size-default" size=Switch.Size.Default />
      <Field.Label for_="switch-size-default"> {"Default"} </Field.Label>
    </Field>
  </Field.Group>
