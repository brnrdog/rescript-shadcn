module Ctx = {
  type t = {
    isOpen: unit => bool,
    setOpen: bool => unit,
    panelId: string,
    triggerId: string,
    disabled: bool,
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
    ~dataSlot: string="collapsible-trigger",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let elementId = switch (id, ctx) {
    | (Some(id), _) => id
    | (None, Some({triggerId})) => triggerId
    | (None, None) => Internal.Id.make("collapsible-trigger")
    }
    let disabled = disabled || ctx->Option.mapOr(false, ctx => ctx.disabled)

    let toggle = _ =>
      switch ctx {
      | Some({isOpen, setOpen}) if !disabled => setOpen(!isOpen())
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
        ("aria-controls", ctx->Option.map(ctx => ctx.panelId)),
        ("data-slot", Some(dataSlot)),
        ("disabled", disabled ? Some("") : None),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~state=() => {
        let open_ = ctx->Option.mapOr(false, ctx => ctx.isOpen())
        [
          ("aria-expanded", Some(open_ ? "true" : "false")),
          ("data-panel-open", open_ ? Some("") : None),
          ("data-open", open_ ? Some("") : None),
          ("data-closed", open_ ? None : Some("")),
        ]
      },
      ~events=[("click", toggle)],
      ~children,
    )
  }
}

module Panel = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="collapsible-panel",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let elementId = switch (id, ctx) {
    | (Some(id), _) => id
    | (None, Some({panelId})) => panelId
    | (None, None) => Internal.Id.make("collapsible-panel")
    }
    let isOpen = ctx->Option.mapOr(() => true, ctx => ctx.isOpen)

    Internal.Panel.bind(~id=elementId, ~cssVariable="--collapsible-panel-height", ~isOpen)

    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", Some(elementId)),
        ("class", className),
        ("style", style),
        ("role", Some("region")),
        ("aria-labelledby", ctx->Option.map(ctx => ctx.triggerId)),
        ("data-slot", Some(dataSlot)),
        ...Signal.untrack(() => {
          let open_ = isOpen()
          [
            ("data-open", open_ ? Some("") : None),
            ("data-closed", open_ ? None : Some("")),
            ("hidden", open_ ? None : Some("")),
          ]
        }),
      ],
      ~children,
    )
  }
}

module Root = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~open_: option<MaybeSignal.t<bool>>=?,
    ~defaultOpen: bool=false,
    ~onOpenChange: option<bool => unit>=?,
    ~disabled: bool=false,
    ~dataSlot: string="collapsible",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("collapsible"))
    let state = Internal.Controlled.make(
      ~value=open_,
      ~defaultValue=defaultOpen,
      ~onChange=onOpenChange,
    )

    let ctx: Ctx.t = {
      isOpen: state.get,
      setOpen: state.set,
      panelId: `${elementId}-panel`,
      triggerId: `${elementId}-trigger`,
      disabled,
    }

    let inner = Internal.Context.provide(context, ctx, children)

    Internal.Node.stateful(
      ~tag="div",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~state=() => {
        let open_ = state.get()
        [("data-open", open_ ? Some("") : None), ("data-closed", open_ ? None : Some(""))]
      },
      ~children=inner,
    )
  }
}
