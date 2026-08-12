@xote.component
let make = () =>
  <Field.Set className="w-full max-w-xs">
    <Field.Group>
      <Field>
        <Field.Label for_="username"> {"Username"} </Field.Label>
        <Input id="username" type_="text" placeholder="Max Leiter" />
        <Field.Description>
          {"Choose a unique username for your account."}
        </Field.Description>
      </Field>
      <Field>
        <Field.Label for_="password"> {"Password"} </Field.Label>
        <Field.Description>
          {"Must be at least 8 characters long."}
        </Field.Description>
        <Input id="password" type_="password" placeholder="••••••••" />
      </Field>
    </Field.Group>
  </Field.Set>
