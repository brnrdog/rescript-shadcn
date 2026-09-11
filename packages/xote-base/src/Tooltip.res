/* Tooltip and hover card share every behaviour except their defaults and the
   role they expose, so one primitive backs both. */

module Ctx = {
  type t = {
    isOpen: unit => bool,
    setOpen: bool => unit,
    triggerId: string,
    popupId: string,
    role: string,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

let use = () => Internal.Context.use(context)

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="tooltip-trigger",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let isOpen = () => ctx->Option.mapOr(false, ctx => ctx.isOpen())
    let setOpen = open_ =>
      switch ctx {
      | Some({setOpen}) => setOpen(open_)
      | None => ()
      }

    <button
      id=?{ctx->Option.map(ctx => ctx.triggerId)->Option.orElse(id)}
      type_="button"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      onMouseEnter={_ => setOpen(true)}
      onMouseLeave={_ => setOpen(false)}
      onFocus={_ => setOpen(true)}
      onBlur={_ => setOpen(false)}
      attrs=[
        View.optionalAttr("aria-describedby", ctx->Option.map(ctx => ctx.popupId)),
        View.attr("data-slot", dataSlot),
        Internal.flag("data-popup-open", isOpen),
      ]>
      {children}
    </button>
  }
}

module Popup = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="tooltip-popup",
    ~attrs: array<(string, View.attrValue)>=[],
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let side = Anchored.useSide()

    <div
      id=?{ctx->Option.map(ctx => ctx.popupId)->Option.orElse(id)}
      role={ctx->Option.mapOr("tooltip", ctx => ctx.role)}
      class=?{className}
      style=?{style}
      attrs={Array.concat([
        View.attr("data-slot", dataSlot),
        View.computedAttr("data-side", () => side()->Anchored.Side.toString),
        View.attr("data-open", ""),
      ], attrs)}>
      {children}
    </div>
  }
}

module Arrow = {
  @xote.component
  let make = (~className: option<string>=?, ~dataSlot: string="tooltip-arrow") => {
    let side = Anchored.useSide()

    <div
      class=?{className}
      attrs=[
        View.attr("data-slot", dataSlot),
        View.computedAttr("data-side", () => side()->Anchored.Side.toString),
        View.attr("aria-hidden", "true"),
      ]
    />
  }
}

module Positioner = {
  @xote.component
  let make = (
    ~side: Anchored.Side.t=Top,
    ~align: Anchored.Align.t=Center,
    ~sideOffset: float=4.,
    ~alignOffset: float=0.,
    ~className: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) =>
    switch use() {
    | Some(ctx) =>
      /* A tooltip never takes focus; it only closes on Escape and on a press
         outside. Hover-out is handled by the trigger. */
      let onMount = _ =>
        Some(
          Internal.Dismiss.attach(
            ~ids=[ctx.popupId, ctx.triggerId],
            ~onDismiss=() => ctx.setOpen(false),
          ),
        )

      let content = Internal.Context.provide(
        context,
        ctx,
        <Anchored.Positioner
          anchorId={ctx.triggerId}
          side
          align
          sideOffset
          alignOffset
          className={className->Option.getOr("pointer-events-none isolate z-50")}
          dataSlot="tooltip-positioner">
          {children}
        </Anchored.Positioner>,
      )

      Internal.Portal.render(~isOpen=ctx.isOpen, ~children=content, ~onMount)
      Internal.noChildren
    | None => Internal.noChildren
    }
}

module Root = {
  @xote.component
  let make = (
    ~id: option<string>=?,
    ~open_: option<MaybeSignal.t<bool>>=?,
    ~defaultOpen: bool=false,
    ~onOpenChange: option<bool => unit>=?,
    /* Milliseconds a pointer has to rest on the trigger before it opens. */
    ~delay: int=0,
    ~closeDelay: int=0,
    ~role: string="tooltip",
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("tooltip"))
    let state = Internal.Controlled.make(
      ~value=open_,
      ~defaultValue=defaultOpen,
      ~onChange=onOpenChange,
    )

    let pending = ref(None)

    let cancel = () =>
      switch pending.contents {
      | Some(timer) =>
        Internal.El.clearTimer(timer)
        pending := None
      | None => ()
      }

    let setOpen = open_ => {
      cancel()
      let wait = open_ ? delay : closeDelay
      if wait <= 0 {
        state.set(open_)
      } else {
        pending :=
          Some(
            Internal.El.setTimer(() => {
              pending := None
              state.set(open_)
            }, wait),
          )
      }
    }

    Internal.El.ownDisposer({dispose: cancel})

    let ctx: Ctx.t = {
      isOpen: state.get,
      setOpen,
      triggerId: `${elementId}-trigger`,
      popupId: `${elementId}-popup`,
      role,
    }

    Internal.Context.provide(context, ctx, children)
  }
}
