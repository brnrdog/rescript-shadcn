@xote.component
let make = () =>
  <Attachment className="w-full max-w-md">
    <Attachment.Media>
      <Icons.FileText />
    </Attachment.Media>
    <Attachment.Content>
      <Attachment.Title> {"research-summary.pdf"} </Attachment.Title>
      <Attachment.Description> {"Click the card to preview"} </Attachment.Description>
    </Attachment.Content>
    <Attachment.Actions>
      <Attachment.Action ariaLabel="Download research-summary.pdf">
        <Icons.Download />
      </Attachment.Action>
    </Attachment.Actions>
    <Attachment.Trigger ariaLabel="Preview research-summary.pdf" />
  </Attachment>
