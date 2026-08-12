module Ctx = {
  type t = {
    isOpen: unit => bool,
    setOpen: bool => unit,
    triggerId: string,
    popupId: string,
    titleId: string,
    descriptionId: string,
    modal: bool,
    dismissible: bool,
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
    ~dataSlot: string="dialog-trigger",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let elementId = switch (id, ctx) {
    | (Some(id), _) => Some(id)
    | (None, Some({triggerId})) => Some(triggerId)
    | (None, None) => None
    }
    let isOpen = () => ctx->Option.mapOr(false, ctx => ctx.isOpen())

    let open_ = _ =>
      switch ctx {
      | Some({setOpen}) if !disabled => setOpen(true)
      | _ => ()
      }

    <button
      id=?{elementId}
      type_="button"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      ariaExpanded={isOpen}
      disabled
      onClick={open_}
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

module Close = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="dialog-close",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()

    <button
      id=?{id}
      type_="button"
      class=?{className}
      style=?{style}
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

module Backdrop = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="dialog-backdrop",
    ~style: option<string>=?,
  ) => {
    let ctx = use()

    <div
      id=?{id}
      class=?{className}
      style=?{style}
      onClick={_ =>
        switch ctx {
        | Some({setOpen, dismissible}) if dismissible => setOpen(false)
        | _ => ()
        }}
      attrs=[View.attr("data-slot", dataSlot), View.attr("data-open", "")]
    />
  }
}

module Popup = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="dialog-popup",
    ~dataSize: option<string>=?,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let elementId = switch (id, ctx) {
    | (Some(id), _) => id
    | (None, Some({popupId})) => popupId
    | (None, None) => Internal.Id.make("dialog-popup")
    }

    <div
      id={elementId}
      role="dialog"
      tabIndex={-1}
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      attrs=[
        View.optionalAttr(
          "aria-modal",
          ctx->Option.mapOr(true, ctx => ctx.modal) ? Some("true") : None,
        ),
        View.optionalAttr(
          "aria-labelledby",
          ariaLabel === None ? ctx->Option.map(ctx => ctx.titleId) : None,
        ),
        View.optionalAttr("aria-describedby", ctx->Option.map(ctx => ctx.descriptionId)),
        View.attr("data-slot", dataSlot),
        View.optionalAttr("data-size", dataSize),
        /* The popup only exists while the dialog is open, so its open state is
           part of the markup rather than a reactive attribute. */
        View.attr("data-open", ""),
      ]>
      {children}
    </div>
  }
}

module Title = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="dialog-title",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()

    <h2
      id=?{id->Option.orElse(ctx->Option.map(ctx => ctx.titleId))}
      class=?{className}
      style=?{style}
      attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </h2>
  }
}

module Description = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="dialog-description",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()

    <p
      id=?{id->Option.orElse(ctx->Option.map(ctx => ctx.descriptionId))}
      class=?{className}
      style=?{style}
      attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </p>
  }
}

module Portal = {
  @xote.component
  let make = (~children: View.node=Internal.noChildren) => {
    switch use() {
    | Some(ctx) =>
      let onMount = element => {
        let previouslyFocused = Internal.El.activeElement()->Nullable.toOption

        Internal.El.focusFirst(element)

        let removeKeyDown = Internal.El.onDocument("keydown", event =>
          if Internal.El.eventKey(event) === "Escape" && ctx.dismissible {
            Internal.El.preventDefault(event)
            ctx.setOpen(false)
          }
        )

        Some(
          () => {
            removeKeyDown()
            switch previouslyFocused {
            | Some(element) => element->Internal.El.focus
            | None => ()
            }
          },
        )
      }

      /* Portal content is mounted later, long after the provider restored the
         previous context value, so re-enter the scope while forcing it. */
      let content = Internal.Context.provide(context, ctx, children)

      Internal.Portal.render(~isOpen=ctx.isOpen, ~children=content, ~onMount)
      Internal.noChildren
    | None => Internal.noChildren
    }
  }
}

module Root = {
  @xote.component
  let make = (
    ~id: option<string>=?,
    ~open_: option<MaybeSignal.t<bool>>=?,
    ~defaultOpen: bool=false,
    ~onOpenChange: option<bool => unit>=?,
    ~modal: bool=true,
    ~dismissible: bool=true,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("dialog"))
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
      dismissible,
    }

    Internal.Context.provide(context, ctx, children)
  }
}
