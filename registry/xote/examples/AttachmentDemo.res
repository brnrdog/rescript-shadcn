@xote.component
let make = () =>
  <Attachment.Group className="w-full max-w-md gap-2">
    <Attachment className="w-64 rounded-lg p-2">
      <Attachment.Media variant=Icon>
        <Icons.Check />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"design-system.pdf"} </Attachment.Title>
        <Attachment.Description> {"2.4 MB"} </Attachment.Description>
      </Attachment.Content>
      <Attachment.Actions>
        <Attachment.Action ariaLabel="Remove attachment">
          <Icons.X />
        </Attachment.Action>
      </Attachment.Actions>
    </Attachment>
    <Attachment state=Uploading className="w-64 rounded-lg p-2">
      <Attachment.Media variant=Icon>
        <Icons.Loader className="animate-spin" />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"screenshot.png"} </Attachment.Title>
        <Attachment.Description> {"Uploading…"} </Attachment.Description>
      </Attachment.Content>
    </Attachment>
  </Attachment.Group>
