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
    | (Some(id), _) => Some(id)
    | (None, Some({triggerId})) => Some(triggerId)
    | (None, None) => None
    }
    let disabled = disabled || ctx->Option.mapOr(false, ctx => ctx.disabled)
    let isOpen = () => ctx->Option.mapOr(false, ctx => ctx.isOpen())

    let toggle = _ =>
      switch ctx {
      | Some({isOpen, setOpen}) if !disabled => setOpen(!isOpen())
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
      onClick={toggle}
      attrs=[
        View.optionalAttr("aria-controls", ctx->Option.map(ctx => ctx.panelId)),
        View.attr("data-slot", dataSlot),
        Internal.flag("data-panel-open", isOpen),
        Internal.flag("data-open", isOpen),
        Internal.flag("data-closed", () => !isOpen()),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      {children}
    </button>
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
    let panel = Internal.Panel.make(
      ~id=elementId,
      ~cssVariable="--collapsible-panel-height",
      ~isOpen,
    )

    <div
      id={elementId}
      role="region"
      class=?{className}
      style=?{style}
      attrs=[
        View.optionalAttr("aria-labelledby", ctx->Option.map(ctx => ctx.triggerId)),
        View.attr("data-slot", dataSlot),
        Internal.flag("data-open", isOpen),
        Internal.flag("data-closed", () => !isOpen()),
        Internal.Panel.hiddenAttr(panel),
      ]>
      {children}
    </div>
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

    <div
      id={elementId}
      class=?{className}
      style=?{style}
      attrs=[
        View.attr("data-slot", dataSlot),
        Internal.flag("data-open", state.get),
        Internal.flag("data-closed", () => !state.get()),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      {Internal.Context.provide(context, ctx, children)}
    </div>
  }
}
