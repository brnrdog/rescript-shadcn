@xote.component
let make = () =>
  <Card className="w-full">
    <Card.Header>
      <Card.Title> {"Card with Input Group"} </Card.Title>
      <Card.Description> {"This is a card with an input group."} </Card.Description>
    </Card.Header>
    <Card.Content>
      <Field.Group>
        <Field>
          <Field.Label for_="email-input"> {"Email Address"} </Field.Label>
          <InputGroup>
            <InputGroup.Input id="email-input" type_="email" placeholder="you@example.com" />
            <InputGroup.Addon align=InlineEnd>
              <Icons.Mail />
            </InputGroup.Addon>
          </InputGroup>
        </Field>
        <Field>
          <Field.Label for_="website-input"> {"Website URL"} </Field.Label>
          <InputGroup>
            <InputGroup.Addon>
              <InputGroup.Text> {"https://"} </InputGroup.Text>
            </InputGroup.Addon>
            <InputGroup.Input id="website-input" placeholder="example.com" />
            <InputGroup.Addon align=InlineEnd>
              <Icons.ExternalLink />
            </InputGroup.Addon>
          </InputGroup>
        </Field>
        <Field>
          <Field.Label for_="feedback-textarea">
            {"Feedback & Comments"}
          </Field.Label>
          <InputGroup>
            <InputGroup.Textarea
              id="feedback-textarea" placeholder="Share your thoughts..." className="min-h-[100px]"
            />
            <InputGroup.Addon align=BlockEnd>
              <InputGroup.Text> {"0/500 characters"} </InputGroup.Text>
            </InputGroup.Addon>
          </InputGroup>
        </Field>
      </Field.Group>
    </Card.Content>
    <Card.Footer className="justify-end gap-2">
      <Button variant=Outline> {"Cancel"} </Button>
      <Button> {"Submit"} </Button>
    </Card.Footer>
  </Card>
