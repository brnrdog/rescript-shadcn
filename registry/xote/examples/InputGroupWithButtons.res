@xote.component
let make = () =>
  <Field.Group>
    <Field>
      <Field.Label for_="input-button-13"> {"Button"} </Field.Label>
      <InputGroup>
        <InputGroup.Input id="input-button-13" />
        <InputGroup.Addon>
          <InputGroup.Button> {"Default"} </InputGroup.Button>
        </InputGroup.Addon>
      </InputGroup>
      <InputGroup>
        <InputGroup.Input id="input-button-14" />
        <InputGroup.Addon>
          <InputGroup.Button variant=Outline> {"Outline"} </InputGroup.Button>
        </InputGroup.Addon>
      </InputGroup>
      <InputGroup>
        <InputGroup.Input id="input-button-15" />
        <InputGroup.Addon>
          <InputGroup.Button variant=Secondary> {"Secondary"} </InputGroup.Button>
        </InputGroup.Addon>
      </InputGroup>
      <InputGroup>
        <InputGroup.Input id="input-button-16" />
        <InputGroup.Addon align=InlineEnd>
          <InputGroup.Button variant=Secondary> {"Button"} </InputGroup.Button>
        </InputGroup.Addon>
      </InputGroup>
      <InputGroup>
        <InputGroup.Input id="input-button-17" />
        <InputGroup.Addon align=InlineEnd>
          <InputGroup.Button size=IconXs>
            <Icons.Copy />
          </InputGroup.Button>
        </InputGroup.Addon>
      </InputGroup>
      <InputGroup>
        <InputGroup.Input id="input-button-18" />
        <InputGroup.Addon align=InlineEnd>
          <InputGroup.Button variant=Secondary size=IconXs>
            <Icons.Trash />
          </InputGroup.Button>
        </InputGroup.Addon>
      </InputGroup>
    </Field>
  </Field.Group>
