@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-3">
    <Attachment className="w-full">
      <Attachment.Media>
        <Icons.FileText />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"sales-dashboard.pdf"} </Attachment.Title>
        <Attachment.Description> {"PDF - 2.4 MB"} </Attachment.Description>
      </Attachment.Content>
      <Attachment.Actions>
        <Attachment.Action ariaLabel="Remove sales-dashboard.pdf">
          <Icons.X />
        </Attachment.Action>
      </Attachment.Actions>
    </Attachment>
    <Attachment className="w-full">
      <Attachment.Media>
        <Icons.FileCode />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"message-renderer.res"} </Attachment.Title>
        <Attachment.Description> {"ReScript - 12 KB"} </Attachment.Description>
      </Attachment.Content>
      <Attachment.Actions>
        <Attachment.Action ariaLabel="Download message-renderer.res">
          <Icons.Download />
        </Attachment.Action>
      </Attachment.Actions>
    </Attachment>
  </div>
