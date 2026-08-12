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
    | (Some(id), _) => id
    | (None, Some({triggerId})) => triggerId
    | (None, None) => Internal.Id.make("dialog-trigger")
    }

    let open_ = _ =>
      switch ctx {
      | Some({setOpen}) if !disabled => setOpen(true)
      | _ => ()
      }

    Internal.Node.stateful(
      ~tag="button",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("type", Some("button")),
        ("aria-label", ariaLabel),
        ("aria-haspopup", Some("dialog")),
        ("aria-controls", ctx->Option.map(ctx => ctx.popupId)),
        ("data-slot", Some(dataSlot)),
        ("disabled", disabled ? Some("") : None),
      ],
      ~state=() => {
        let open_ = ctx->Option.mapOr(false, ctx => ctx.isOpen())
        [
          ("aria-expanded", Some(open_ ? "true" : "false")),
          ("data-popup-open", open_ ? Some("") : None),
        ]
      },
      ~events=[("click", open_)],
      ~children,
    )
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

    Internal.Node.make(
      ~tag="button",
      ~attrs=[
        ("id", id),
        ("class", className),
        ("style", style),
        ("type", Some("button")),
        ("aria-label", ariaLabel),
        ("data-slot", Some(dataSlot)),
      ],
      ~events=[
        (
          "click",
          _ =>
            switch ctx {
            | Some({setOpen}) => setOpen(false)
            | None => ()
            },
        ),
      ],
      ~children,
    )
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

    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", id),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
        ("data-open", Some("")),
      ],
      ~events=[
        (
          "click",
          _ =>
            switch ctx {
            | Some({setOpen, dismissible}) if dismissible => setOpen(false)
            | _ => ()
            },
        ),
      ],
    )
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

    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", Some(elementId)),
        ("class", className),
        ("style", style),
        ("role", Some("dialog")),
        ("tabindex", Some("-1")),
        ("aria-modal", ctx->Option.mapOr(true, ctx => ctx.modal) ? Some("true") : None),
        ("aria-label", ariaLabel),
        ("aria-labelledby", ariaLabel === None ? ctx->Option.map(ctx => ctx.titleId) : None),
        ("aria-describedby", ctx->Option.map(ctx => ctx.descriptionId)),
        ("data-slot", Some(dataSlot)),
        ("data-size", dataSize),
        /* The popup only exists while the dialog is open, so its open state is
           part of the markup rather than a reactive attribute. */
        ("data-open", Some("")),
      ],
      ~children,
    )
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

    Internal.Node.make(
      ~tag="h2",
      ~attrs=[
        ("id", id->Option.orElse(ctx->Option.map(ctx => ctx.titleId))),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
      ],
      ~children,
    )
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

    Internal.Node.make(
      ~tag="p",
      ~attrs=[
        ("id", id->Option.orElse(ctx->Option.map(ctx => ctx.descriptionId))),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
      ],
      ~children,
    )
  }
}

module Portal = {
  @xote.component
  let make = (~children: View.node=Internal.noChildren) => {
    let ctx = use()

    switch ctx {
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
