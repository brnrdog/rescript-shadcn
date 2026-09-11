@xote.component
let make = () =>
  <Field.Set className="w-full max-w-sm">
    <Field.Legend> {"Address Information"} </Field.Legend>
    <Field.Description>
      {"We need your address to deliver your order."}
    </Field.Description>
    <Field.Group>
      <Field>
        <Field.Label for_="street"> {"Street Address"} </Field.Label>
        <Input id="street" type_="text" placeholder="123 Main St" />
      </Field>
      <div class="grid grid-cols-2 gap-4">
        <Field>
          <Field.Label for_="city"> {"City"} </Field.Label>
          <Input id="city" type_="text" placeholder="New York" />
        </Field>
        <Field>
          <Field.Label for_="zip"> {"Postal Code"} </Field.Label>
          <Input id="zip" type_="text" placeholder="90502" />
        </Field>
      </div>
    </Field.Group>
  </Field.Set>
