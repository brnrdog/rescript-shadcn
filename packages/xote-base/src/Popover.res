module Ctx = {
  type t = {
    isOpen: unit => bool,
    setOpen: bool => unit,
    triggerId: string,
    popupId: string,
    titleId: string,
    descriptionId: string,
    modal: bool,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

let use = () => Internal.Context.use(context)

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="popover-trigger",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let isOpen = () => ctx->Option.mapOr(false, ctx => ctx.isOpen())

    let toggle = _ =>
      switch ctx {
      | Some({isOpen, setOpen}) if !disabled => setOpen(!isOpen())
      | _ => ()
      }

    <button
      id=?{ctx->Option.map(ctx => ctx.triggerId)->Option.orElse(id)}
      type_="button"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      ariaExpanded={isOpen}
      disabled
      onClick={toggle}
      attrs=[
        View.attr("aria-haspopup", "dialog"),
        View.optionalAttr("aria-controls", ctx->Option.map(ctx => ctx.popupId)),
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
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="popover-popup",
    ~attrs: array<(string, View.attrValue)>=[],
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let side = Anchored.useSide()

    <div
      id=?{ctx->Option.map(ctx => ctx.popupId)->Option.orElse(id)}
      role="dialog"
      tabIndex={-1}
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      attrs={Array.concat([
        View.optionalAttr(
          "aria-labelledby",
          ariaLabel === None ? ctx->Option.map(ctx => ctx.titleId) : None,
        ),
        View.attr("data-slot", dataSlot),
        View.computedAttr("data-side", () => side()->Anchored.Side.toString),
        /* The popup exists only while open, so its open state is markup. */
        View.attr("data-open", ""),
      ], attrs)}>
      {children}
    </div>
  }
}

module Title = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="popover-title",
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()

    <h3
      id=?{id->Option.orElse(ctx->Option.map(ctx => ctx.titleId))}
      class=?{className}
      attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </h3>
  }
}

module Description = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="popover-description",
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()

    <p
      id=?{id->Option.orElse(ctx->Option.map(ctx => ctx.descriptionId))}
      class=?{className}
      attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </p>
  }
}

module Close = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="popover-close",
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()

    <button
      id=?{id}
      type_="button"
      class=?{className}
      ariaLabel=?{ariaLabel}
      onClick={_ =>
        switch ctx {
        | Some({setOpen}) => setOpen(false)
        | None => ()
        }}
      attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </button>
  }
}

/* Portal + positioner in one, so a styled component only spells out the popup. */
module Positioner = {
  @xote.component
  let make = (
    ~side: Anchored.Side.t=Bottom,
    ~align: Anchored.Align.t=Center,
    ~sideOffset: float=4.,
    ~alignOffset: float=0.,
    ~className: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) =>
    switch use() {
    | Some(ctx) =>
      let onMount = element => {
        let previouslyFocused = Internal.El.activeElement()->Nullable.toOption
        Internal.El.focusFirst(element)

        let stopDismiss = Internal.Dismiss.attach(
          ~ids=[ctx.popupId, ctx.triggerId],
          ~onDismiss=() => ctx.setOpen(false),
        )

        Some(
          () => {
            stopDismiss()
            switch previouslyFocused {
            | Some(element) => element->Internal.El.focus
            | None => ()
            }
          },
        )
      }

      let content = Internal.Context.provide(
        context,
        ctx,
        <Anchored.Positioner
          anchorId={ctx.triggerId}
          side
          align
          sideOffset
          alignOffset
          className={className->Option.getOr("isolate z-50")}
          dataSlot="popover-positioner">
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
    ~modal: bool=false,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("popover"))
    let state = Internal.Controlled.make(
      ~value=open_,
      ~defaultValue=defaultOpen,
      ~onChange=onOpenChange,
    )

    let ctx: Ctx.t = {
      isOpen: state.get,
      setOpen: state.set,
      triggerId: `${elementId}-trigger`,
      popupId: `${elementId}-popup`,
      titleId: `${elementId}-title`,
      descriptionId: `${elementId}-description`,
      modal,
    }

    Internal.Context.provide(context, ctx, children)
  }
}
