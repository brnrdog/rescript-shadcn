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
        switch (
          Internal.El.eventCurrentTarget(event)->Nullable.toOption,
          Internal.El.eventTarget(event)->Nullable.toOption,
        ) {
        | (Some(list), Some(target)) =>
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
        | _ => ()
        }
      }
    }

    <div
      id=?{id}
      role="tablist"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      onKeyDown={onKeyDown}
      attrs=[
        View.attr("aria-orientation", orientation->Internal.Orientation.toString),
        View.attr("data-slot", dataSlot),
        View.optionalAttr("data-variant", dataVariant),
      ]>
      {children}
    </div>
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
    let disabled = disabled || ctx->Option.mapOr(false, ctx => ctx.disabled)
    let isActive = () => ctx->Option.mapOr(false, ctx => ctx.activeValue() === value)

    let select = _ =>
      switch ctx {
      | Some({setValue}) if !disabled => setValue(value)
      | _ => ()
      }

    <button
      id={id->Option.getOr(tabId(rootId, value))}
      type_="button"
      role="tab"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      ariaSelected={isActive}
      disabled
      onClick={select}
      attrs=[
        View.attr("aria-controls", panelId(rootId, value)),
        View.computedAttr("tabindex", () => isActive() ? "0" : "-1"),
        View.attr("data-slot", dataSlot),
        Internal.flag("data-active", isActive),
        Internal.flag("data-selected", isActive),
        Internal.flag("data-inactive", () => !isActive()),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      {children}
    </button>
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
    let isActive = () => ctx->Option.mapOr(true, ctx => ctx.activeValue() === value)

    let panel =
      <div
        id={id->Option.getOr(panelId(rootId, value))}
        role="tabpanel"
        tabIndex={0}
        class=?{className}
        style=?{style}
        attrs=[
          View.attr("aria-labelledby", tabId(rootId, value)),
          View.attr("data-slot", dataSlot),
          Internal.flag("data-active", isActive),
          View.optionalComputedAttr("hidden", () =>
            !keepMounted || isActive() ? None : Some("true")
          ),
        ]>
        {children}
      </div>

    keepMounted ? panel : View.Show.make({when_: MaybeSignal.computed(isActive), children: panel})
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
    let name = orientation->Internal.Orientation.toString

    let ctx: Ctx.t = {
      activeValue: state.get,
      setValue: state.set,
      orientation,
      rootId: elementId,
      disabled,
    }

    <div
      id={elementId}
      class=?{className}
      style=?{style}
      attrs=[
        View.attr("data-slot", dataSlot),
        View.attr(`data-${name}`, ""),
        View.attr("data-orientation", name),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      {Internal.Context.provide(context, ctx, children)}
    </div>
  }
}
