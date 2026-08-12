let messages = Array.fromInitializer(~length=12, index => `Message ${(index + 1)->Int.toString}`)

@xote.component
let make = () =>
  <div class="h-[480px] w-full max-w-xl rounded-lg border">
    <MessageScroller ariaLabel="Conversation">
      <View.For
        each={MaybeSignal.static(messages)}
        by={message => message}
        render={message =>
          <MessageScroller.Item className="px-4 py-2">
            <Bubble>
              <Bubble.Content> {message} </Bubble.Content>
            </Bubble>
          </MessageScroller.Item>}
      />
    </MessageScroller>
  </div>
