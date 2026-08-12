@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Internal = XoteBase.Internal
module Orientation = XoteBase.Internal.Orientation

/* Two panels either side of a draggable handle. The handle writes a percentage
   into a CSS variable on the group, so resizing is one style write. */
module Ctx = {
  type t = {
    ratio: Signal.t<float>,
    orientation: Orientation.t,
    groupId: string,
  }
}

let context: XoteBase.Internal.Context.t<Ctx.t> = XoteBase.Internal.Context.make()

let dragRatio: (Dom.element, Dom.event, bool) => float = %raw(`function (el, event, vertical) {
  const rect = el.getBoundingClientRect()
  const ratio = vertical
    ? (event.clientY - rect.top) / rect.height
    : (event.clientX - rect.left) / rect.width
  return Math.min(0.9, Math.max(0.1, ratio)) * 100
}`)

/* The handle is a hairline, so without capture the pointer leaves it after the
   first pixel and the drag dies there. Capture retargets every later move and
   the release to the handle, wherever the pointer actually is. */
let capturePointer: Dom.event => unit = %raw(`function (event) {
  event.preventDefault()
  event.currentTarget.setPointerCapture(event.pointerId)
}`)

let releasePointer: Dom.event => unit = %raw(`function (event) {
  if (event.currentTarget.hasPointerCapture(event.pointerId)) {
    event.currentTarget.releasePointerCapture(event.pointerId)
  }
}`)

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~orientation: Orientation.t=Horizontal,
  ~defaultRatio: float=50.,
  ~children: View.node=View.fragment([]),
) => {
  let groupId = id->Option.getOr(XoteBase.Internal.Id.make("resizable"))
  let ratio = Signal.make(defaultRatio)

  <div
    id={groupId}
    class={cn(
      "cn-resizable-panel-group flex h-full w-full aria-[orientation=vertical]:flex-col",
      className,
    )}
    style={() => `--resizable-ratio: ${Signal.get(ratio)->Float.toString}%`}
    attrs=[
      View.attr("data-slot", "resizable-panel-group"),
      View.attr("aria-orientation", orientation->Orientation.toString),
    ]>
    {XoteBase.Internal.Context.provide(context, {ratio, orientation, groupId}, children)}
  </div>
}

module Panel = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    /* The first panel follows the handle; the second takes what is left. */
    ~grow: bool=false,
    ~defaultSize: option<float>=?,
    ~children: View.node=View.fragment([]),
  ) => {
    let ctx = XoteBase.Internal.Context.use(context)

    /* A starting size belongs to the group, not to this panel — pinning the
       panel's basis here would take it out of the drag entirely. */
    switch (ctx, defaultSize, grow) {
    | (Some(ctx), Some(size), false) => Signal.set(ctx.ratio, size)
    | _ => ()
    }

    <div
      id=?{id}
      class={cn("cn-resizable-panel min-h-0 min-w-0 overflow-hidden", className)}
      style={grow ? "flex: 1 1 auto" : "flex: 0 0 var(--resizable-ratio)"}
      attrs=[View.attr("data-slot", "resizable-panel")]>
      {children}
    </div>
  }
}

module Handle = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~withHandle: bool=false) => {
    let ctx = XoteBase.Internal.Context.use(context)
    let dragging = ref(false)
    let active = Signal.make(false)
    let orientation = ctx->Option.mapOr(Orientation.Horizontal, ctx => ctx.orientation)

    let update = event =>
      switch ctx {
      | Some(ctx) =>
        switch XoteBase.Internal.El.getElementById(ctx.groupId)->Nullable.toOption {
        | Some(group) =>
          Signal.set(ctx.ratio, dragRatio(group, event, orientation === Vertical))
        | None => ()
        }
      | None => ()
      }

    let onKeyDown = event =>
      switch ctx {
      | Some(ctx) =>
        let step = switch XoteBase.Internal.El.eventKey(event) {
        | "ArrowLeft" | "ArrowUp" => Some(-2.)
        | "ArrowRight" | "ArrowDown" => Some(2.)
        | _ => None
        }
        switch step {
        | Some(step) =>
          XoteBase.Internal.El.preventDefault(event)
          Signal.set(ctx.ratio, Math.min(90., Math.max(10., Signal.get(ctx.ratio) +. step)))
        | None => ()
        }
      | None => ()
      }

    <div
      id=?{id}
      role="separator"
      tabIndex={0}
      class={cn(
        "cn-resizable-handle relative flex w-px items-center justify-center bg-border ring-offset-background after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2 focus-visible:ring-1 focus-visible:ring-ring focus-visible:outline-hidden aria-[orientation=horizontal]:h-px aria-[orientation=horizontal]:w-full aria-[orientation=horizontal]:after:left-0 aria-[orientation=horizontal]:after:h-1 aria-[orientation=horizontal]:after:w-full aria-[orientation=horizontal]:after:translate-x-0 aria-[orientation=horizontal]:after:-translate-y-1/2 [&[aria-orientation=horizontal]>div]:rotate-90",
        className,
      )}
      style="touch-action: none"
      onPointerDown={event => {
        dragging := true
        capturePointer(event)
        Signal.set(active, true)
        update(event)
      }}
      onPointerMove={event =>
        if dragging.contents {
          update(event)
        }}
      onPointerUp={event => {
        dragging := false
        releasePointer(event)
        Signal.set(active, false)
      }}
      onPointerCancel={event => {
        dragging := false
        releasePointer(event)
        Signal.set(active, false)
      }}
      onKeyDown={onKeyDown}
      attrs=[
        View.attr("data-slot", "resizable-handle"),
        View.attr(
          "aria-orientation",
          orientation === Vertical ? "horizontal" : "vertical",
        ),
        Internal.flag("data-dragging", () => Signal.get(active)),
        View.computedAttr("aria-valuenow", () =>
          ctx->Option.mapOr("50", ctx => Signal.get(ctx.ratio)->Float.toFixed(~digits=0))
        ),
        View.attr("aria-valuemin", "10"),
        View.attr("aria-valuemax", "90"),
      ]>
      {withHandle
        ? <div class="cn-resizable-handle-icon z-10 flex shrink-0">
            <Icons.MoreHorizontal className="size-3" />
          </div>
        : View.fragment([])}
    </div>
  }
}
