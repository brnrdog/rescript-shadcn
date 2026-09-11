@xote.component
let make = () =>
  <Attachment.Group className="w-full max-w-md">
    <Attachment orientation=Vertical>
      <Attachment.Media>
        <Icons.FileText />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"brief.pdf"} </Attachment.Title>
        <Attachment.Description> {"PDF - 640 KB"} </Attachment.Description>
      </Attachment.Content>
    </Attachment>
    <Attachment orientation=Vertical>
      <Attachment.Media>
        <Icons.FileCode />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"schema.sql"} </Attachment.Title>
        <Attachment.Description> {"SQL - 18 KB"} </Attachment.Description>
      </Attachment.Content>
    </Attachment>
    <Attachment orientation=Vertical>
      <Attachment.Media>
        <Icons.Image />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"wireframe.png"} </Attachment.Title>
        <Attachment.Description> {"PNG - 420 KB"} </Attachment.Description>
      </Attachment.Content>
    </Attachment>
  </Attachment.Group>
