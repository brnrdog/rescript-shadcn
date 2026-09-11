@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-8">
    <Message align=End>
      <Message.Content>
        <Bubble>
          <Bubble.Content> {"Can you review this file?"} </Bubble.Content>
        </Bubble>
        <Attachment className="mt-2 w-full">
          <Attachment.Media>
            <Icons.FileText />
          </Attachment.Media>
          <Attachment.Content>
            <Attachment.Title> {"release-notes.md"} </Attachment.Title>
            <Attachment.Description> {"Markdown - 8 KB"} </Attachment.Description>
          </Attachment.Content>
        </Attachment>
      </Message.Content>
    </Message>
    <Message>
      <Message.Content>
        <Bubble variant=Muted>
          <Bubble.Content> {"The structure looks right. I left two comments."} </Bubble.Content>
        </Bubble>
      </Message.Content>
    </Message>
  </div>
