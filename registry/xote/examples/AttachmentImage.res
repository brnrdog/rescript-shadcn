@xote.component
let make = () =>
  <div class="flex w-full max-w-md gap-3">
    <Attachment orientation=Vertical className="w-40">
      <Attachment.Media variant=Image>
        <img
          src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&auto=format&fit=crop&q=80"
          alt="Analytics dashboard"
          class="grayscale"
        />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"dashboard.png"} </Attachment.Title>
        <Attachment.Description> {"PNG - 820 KB"} </Attachment.Description>
      </Attachment.Content>
    </Attachment>
    <Attachment orientation=Vertical className="w-40">
      <Attachment.Media variant=Image>
        <img
          src="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&auto=format&fit=crop&q=80"
          alt="Laptop with notes"
          class="grayscale"
        />
      </Attachment.Media>
      <Attachment.Content>
        <Attachment.Title> {"research.jpg"} </Attachment.Title>
        <Attachment.Description> {"JPEG - 1.1 MB"} </Attachment.Description>
      </Attachment.Content>
    </Attachment>
  </div>
