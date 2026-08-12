@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* A chat log that keeps itself pinned to the newest message, with a button to
   jump back down once you scroll away. */
let isNearBottom: Dom.element => bool = %raw(`function (el) {
  return el.scrollHeight - el.scrollTop - el.clientHeight < 32
}`)

let scrollToBottom: (Dom.element, bool) => unit = %raw(`function (el, smooth) {
  el.scrollTo({ top: el.scrollHeight, behavior: smooth ? "smooth" : "auto" })
}`)

let observeContent: (Dom.element, unit => unit) => unit => unit = %raw(`function (el, onChange) {
  if (typeof ResizeObserver === "undefined") { return function () {} }
  const observer = new ResizeObserver(onChange)
  observer.observe(el)
  Array.prototype.forEach.call(el.children, child => observer.observe(child))
  return function () { observer.disconnect() }
}`)

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) => {
  let viewportId = XoteBase.Internal.Id.make("message-scroller-viewport")
  let atBottom = Signal.make(true)

  XoteBase.Internal.El.withElement(viewportId, viewport => {
    let sync = () => Signal.set(atBottom, isNearBottom(viewport))

    /* New content scrolls into view only while the reader is already at the
       bottom, so scrolling up is never yanked away. */
    let stopObserving = observeContent(viewport, () =>
      if Signal.peek(atBottom) {
        scrollToBottom(viewport, false)
      }
    )

    viewport->XoteBase.Internal.El.addEventListener("scroll", _ => sync())
    scrollToBottom(viewport, false)

    XoteBase.Internal.El.ownDisposer({dispose: stopObserving})
  })

  <div
    id=?{id}
    class={cn(
      "cn-message-scroller group/message-scroller relative flex size-full min-h-0 flex-col overflow-hidden",
      className,
    )}
    attrs=[View.attr("data-slot", "message-scroller")]>
    <div
      id={viewportId}
      ariaLabel=?{ariaLabel}
      class="cn-message-scroller-viewport size-full min-h-0 min-w-0 overflow-y-auto overscroll-contain"
      attrs=[View.attr("data-slot", "message-scroller-viewport"), View.attr("role", "log")]>
      <div
        class="cn-message-scroller-content flex h-max min-h-full flex-col"
        attrs=[View.attr("data-slot", "message-scroller-content")]>
        {children}
      </div>
    </div>
    <Button
      variant=Outline
      size=IconSm
      ariaLabel="Scroll to latest"
      onClick={_ =>
        switch XoteBase.Internal.El.getElementById(viewportId)->Nullable.toOption {
        | Some(viewport) => scrollToBottom(viewport, true)
        | None => ()
        }}
      dataSlot="message-scroller-button"
      className="cn-message-scroller-button absolute bottom-4 left-1/2 -translate-x-1/2 rounded-full transition-opacity data-[active=false]:pointer-events-none data-[active=false]:opacity-0">
      <Icons.ChevronDown />
    </Button>
  </div>
}

module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-message-scroller-item min-w-0 shrink-0", className)}
      attrs=[View.attr("data-slot", "message-scroller-item")]>
      {children}
    </div>
}
