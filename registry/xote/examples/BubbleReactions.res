@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-12">
    <Bubble variant=Muted>
      <Bubble.Content> {"Classname parity is passing."} </Bubble.Content>
      <Bubble.Reactions role="img" ariaLabel="Reactions: thumbs up and fire">
        <span> {"+1"} </span>
        <span> {"reviewed"} </span>
      </Bubble.Reactions>
    </Bubble>
    <Bubble align=End>
      <Bubble.Content> {"Run the pixel test too."} </Bubble.Content>
      <Bubble.Reactions side=Top align=Start>
        <Button variant=Secondary size=IconXs ariaLabel="Thumbs up">
          <Icons.Check />
        </Button>
      </Bubble.Reactions>
    </Bubble>
  </div>
