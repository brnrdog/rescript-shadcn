@xote.component
let make = () =>
  <Field.Group>
    <Field>
      <Field.Label for_="input-icon-left-05">
        {"Addon (inline-start)"}
      </Field.Label>
      <InputGroup>
        <InputGroup.Input id="input-icon-left-05" />
        <InputGroup.Addon>
          <Icons.Search className="text-muted-foreground" />
        </InputGroup.Addon>
      </InputGroup>
    </Field>
    <Field>
      <Field.Label for_="input-icon-right-07">
        {"Addon (inline-end)"}
      </Field.Label>
      <InputGroup>
        <InputGroup.Input id="input-icon-right-07" />
        <InputGroup.Addon align=InlineEnd>
          <Icons.EyeOff />
        </InputGroup.Addon>
      </InputGroup>
    </Field>
    <Field>
      <Field.Label for_="input-icon-both-09">
        {"Addon (inline-start and inline-end)"}
      </Field.Label>
      <InputGroup>
        <InputGroup.Input id="input-icon-both-09" />
        <InputGroup.Addon>
          <Icons.Mic className="text-muted-foreground" />
        </InputGroup.Addon>
        <InputGroup.Addon align=InlineEnd>
          <Icons.Radio className="animate-pulse text-red-500" />
        </InputGroup.Addon>
      </InputGroup>
    </Field>
    <Field>
      <Field.Label for_="input-addon-20"> {"Addon (block-start)"} </Field.Label>
      <InputGroup className="h-auto">
        <InputGroup.Input id="input-addon-20" />
        <InputGroup.Addon align=BlockStart>
          <InputGroup.Text> {"First Name"} </InputGroup.Text>
          <Icons.Info className="text-muted-foreground ml-auto" />
        </InputGroup.Addon>
      </InputGroup>
    </Field>
    <Field>
      <Field.Label for_="input-addon-21"> {"Addon (block-end)"} </Field.Label>
      <InputGroup className="h-auto">
        <InputGroup.Input id="input-addon-21" />
        <InputGroup.Addon align=BlockEnd>
          <InputGroup.Text> {"20/240 characters"} </InputGroup.Text>
          <Icons.Info className="text-muted-foreground ml-auto" />
        </InputGroup.Addon>
      </InputGroup>
    </Field>
    <Field>
      <Field.Label for_="input-icon-both-10"> {"Multiple Icons"} </Field.Label>
      <InputGroup>
        <InputGroup.Input id="input-icon-both-10" />
        <InputGroup.Addon align=InlineEnd>
          <Icons.Star />
          <InputGroup.Button size=IconXs>
            <Icons.Copy />
          </InputGroup.Button>
        </InputGroup.Addon>
        <InputGroup.Addon>
          <Icons.Radio className="animate-pulse text-red-500" />
        </InputGroup.Addon>
      </InputGroup>
    </Field>
    <Field>
      <Field.Label for_="input-description-10"> {"Description"} </Field.Label>
      <InputGroup>
        <InputGroup.Input id="input-description-10" />
        <InputGroup.Addon align=InlineEnd>
          <Icons.Info />
        </InputGroup.Addon>
      </InputGroup>
      <Field.Description>
        {"This is a description of the input group."}
      </Field.Description>
    </Field>
    <Field>
      <Field.Label for_="input-label-10"> {"Label"} </Field.Label>
      <InputGroup>
        <InputGroup.Addon>
          <Field.Label for_="input-label-10"> {"Label"} </Field.Label>
        </InputGroup.Addon>
        <InputGroup.Input id="input-label-10" />
      </InputGroup>
      <InputGroup>
        <InputGroup.Input id="input-optional-12" ariaLabel="Optional" />
        <InputGroup.Addon align=InlineEnd>
          <InputGroup.Text> {"(optional)"} </InputGroup.Text>
        </InputGroup.Addon>
      </InputGroup>
    </Field>
  </Field.Group>
