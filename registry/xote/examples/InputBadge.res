@xote.component
let make = () =>
  <Field>
    <Field.Label for_="input-badge">
      {"Webhook URL "}
      <Badge variant=Secondary className="ml-auto"> {"Beta"} </Badge>
    </Field.Label>
    <Input id="input-badge" type_="url" placeholder="https://api.example.com/webhook" />
  </Field>
