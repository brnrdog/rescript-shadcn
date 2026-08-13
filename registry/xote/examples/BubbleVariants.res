@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-5">
    <Bubble>
      <Bubble.Content> {"Default bubble for the current user."} </Bubble.Content>
    </Bubble>
    <Bubble variant=Secondary>
      <Bubble.Content> {"Secondary bubble for conversation content."} </Bubble.Content>
    </Bubble>
    <Bubble variant=Muted>
      <Bubble.Content> {"Muted bubble for quiet supporting details."} </Bubble.Content>
    </Bubble>
    <Bubble variant=Outline>
      <Bubble.Content> {"Outline bubble for framed content."} </Bubble.Content>
    </Bubble>
    <Bubble variant=Ghost>
      <Bubble.Content>
        <span class="whitespace-pre-wrap">
          {"Ghost bubbles work well for assistant text that should use the full row."}
        </span>
      </Bubble.Content>
    </Bubble>
  </div>
