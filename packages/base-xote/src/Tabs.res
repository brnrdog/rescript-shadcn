module Ctx = {
  type t = {
    activeValue: unit => string,
    setValue: string => unit,
    orientation: Internal.Orientation.t,
    rootId: string,
    disabled: bool,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

let tabId = (rootId, value) => `${rootId}-tab-${value}`
let panelId = (rootId, value) => `${rootId}-panel-${value}`

module List = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="tabs-list",
    ~dataVariant: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = Internal.Context.use(context)
    let orientation = ctx->Option.mapOr(Internal.Orientation.Horizontal, ctx => ctx.orientation)

    /* Roving focus inside the tab list, as required by the tabs pattern. */
    let onKeyDown = event => {
      let key = Internal.El.eventKey(event)
      let isNext = key === (orientation === Vertical ? "ArrowDown" : "ArrowRight")
      let isPrevious = key === (orientation === Vertical ? "ArrowUp" : "ArrowLeft")

      if isNext || isPrevious || key === "Home" || key === "End" {
        switch Internal.El.eventTarget(event)->Nullable.toOption {
        | None => ()
        | Some(target) =>
          switch target->Internal.El.closest(`[data-slot="tabs-list"]`)->Nullable.toOption {
          | None => ()
          | Some(list) =>
            let tabs = Internal.El.querySelectorAll(list, `[role="tab"]:not([disabled])`)
            switch tabs->Array.findIndexOpt(tab => tab->Internal.El.contains(target)) {
            | None => ()
            | Some(index) =>
              let last = tabs->Array.length - 1
              let nextIndex = switch key {
              | "Home" => 0
              | "End" => last
              | _ if isNext => index === last ? 0 : index + 1
              | _ => index === 0 ? last : index - 1
              }
              switch tabs->Array.get(nextIndex) {
              | Some(tab) =>
                Internal.El.preventDefault(event)
                tab->Internal.El.focus
                tab->Internal.El.click
              | None => ()
              }
            }
          }
        }
      }
    }

    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", id),
        ("class", className),
        ("style", style),
        ("role", Some("tablist")),
        ("aria-label", ariaLabel),
        ("aria-orientation", Some(orientation->Internal.Orientation.toString)),
        ("data-slot", Some(dataSlot)),
        ("data-variant", dataVariant),
      ],
      ~events=[("keydown", onKeyDown)],
      ~children,
    )
  }
}

module Tab = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="tabs-trigger",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = Internal.Context.use(context)
    let rootId = ctx->Option.mapOr("tabs", ctx => ctx.rootId)
    let elementId = id->Option.getOr(tabId(rootId, value))
    let disabled = disabled || ctx->Option.mapOr(false, ctx => ctx.disabled)
    let isActive = () => ctx->Option.mapOr(false, ctx => ctx.activeValue() === value)

    let select = _ =>
      switch ctx {
      | Some({setValue}) if !disabled => setValue(value)
      | _ => ()
      }

    Internal.Node.stateful(
      ~tag="button",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("type", Some("button")),
        ("role", Some("tab")),
        ("aria-label", ariaLabel),
        ("aria-controls", Some(panelId(rootId, value))),
        ("data-slot", Some(dataSlot)),
        ("disabled", disabled ? Some("") : None),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~state=() => {
        let active = isActive()
        [
          ("aria-selected", Some(active ? "true" : "false")),
          ("tabindex", Some(active ? "0" : "-1")),
          ("data-active", active ? Some("") : None),
          ("data-selected", active ? Some("") : None),
          ("data-inactive", active ? None : Some("")),
        ]
      },
      ~events=[("click", select)],
      ~children,
    )
  }
}

module Panel = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~keepMounted: bool=true,
    ~dataSlot: string="tabs-content",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = Internal.Context.use(context)
    let rootId = ctx->Option.mapOr("tabs", ctx => ctx.rootId)
    let elementId = id->Option.getOr(panelId(rootId, value))
    let isActive = () => ctx->Option.mapOr(true, ctx => ctx.activeValue() === value)

    let panel = Internal.Node.stateful(
      ~tag="div",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("role", Some("tabpanel")),
        ("tabindex", Some("0")),
        ("aria-labelledby", Some(tabId(rootId, value))),
        ("data-slot", Some(dataSlot)),
      ],
      ~state=() => {
        let active = isActive()
        [
          ("hidden", active || !keepMounted ? None : Some("")),
          ("data-active", active ? Some("") : None),
        ]
      },
      ~children,
    )

    keepMounted
      ? panel
      : View.Show.make({when_: MaybeSignal.computed(isActive), children: panel})
  }
}

module Root = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~value: option<MaybeSignal.t<string>>=?,
    ~defaultValue: string="",
    ~onValueChange: option<string => unit>=?,
    ~orientation: Internal.Orientation.t=Horizontal,
    ~disabled: bool=false,
    ~dataSlot: string="tabs",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("tabs"))
    let state = Internal.Controlled.make(~value, ~defaultValue, ~onChange=onValueChange)

    let ctx: Ctx.t = {
      activeValue: state.get,
      setValue: state.set,
      orientation,
      rootId: elementId,
      disabled,
    }

    let inner = Internal.Context.provide(context, ctx, children)

    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", Some(elementId)),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
        (`data-${orientation->Internal.Orientation.toString}`, Some("")),
        ("data-orientation", Some(orientation->Internal.Orientation.toString)),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~children=inner,
    )
  }
}
