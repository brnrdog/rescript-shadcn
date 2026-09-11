@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-8">
    <Bubble variant=Muted>
      <Bubble.Content>
        {"I checked the registry output and found one stale dependency."}
      </Bubble.Content>
    </Bubble>
    <Bubble align=End>
      <Bubble.Content> {"Remove it and rerun the build."} </Bubble.Content>
      <Bubble.Reactions>
        <span> {"+1"} </span>
      </Bubble.Reactions>
    </Bubble>
  </div>
