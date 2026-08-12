@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-3">
    <Attachment state=Uploading className="w-full">
      <Attachment.Media>
        <Icons.FileText />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"quarterly-review.pdf"} </Attachment.Title>
        <Attachment.Description> {"Uploading..."} </Attachment.Description>
      </Attachment.Content>
      <Attachment.Actions>
        <Spinner className="size-4" />
      </Attachment.Actions>
    </Attachment>
    <Attachment state=Processing className="w-full">
      <Attachment.Media>
        <Icons.FileCode />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"transcript.json"} </Attachment.Title>
        <Attachment.Description> {"Processing metadata"} </Attachment.Description>
      </Attachment.Content>
    </Attachment>
    <Attachment state=Error className="w-full">
      <Attachment.Media>
        <Icons.TriangleAlert />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"large-export.zip"} </Attachment.Title>
        <Attachment.Description> {"Upload failed"} </Attachment.Description>
      </Attachment.Content>
      <Attachment.Actions>
        <Button variant=Outline size=Sm> {"Retry"} </Button>
      </Attachment.Actions>
    </Attachment>
  </div>
