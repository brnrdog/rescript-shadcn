module Ctx = {
  type t = {
    isOpen: string => bool,
    toggle: string => unit,
    disabled: bool,
    loopFocus: bool,
  }
}

module ItemCtx = {
  type t = {
    value: string,
    triggerId: string,
    panelId: string,
    isOpen: unit => bool,
    toggle: unit => unit,
    disabled: bool,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()
let itemContext: Internal.Context.t<ItemCtx.t> = Internal.Context.make()

module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~value: option<string>=?,
    ~disabled: bool=false,
    ~dataSlot: string="accordion-item",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("accordion-item"))
    let itemValue = value->Option.getOr(elementId)
    let root = Internal.Context.use(context)
    let disabled = disabled || root->Option.mapOr(false, root => root.disabled)

    let isOpen = () => root->Option.mapOr(false, root => root.isOpen(itemValue))
    let toggle = () =>
      switch root {
      | Some(root) if !disabled => root.toggle(itemValue)
      | _ => ()
      }

    let itemCtx: ItemCtx.t = {
      value: itemValue,
      triggerId: `${elementId}-trigger`,
      panelId: `${elementId}-panel`,
      isOpen,
      toggle,
      disabled,
    }

    <div
      id={elementId}
      class=?{className}
      style=?{style}
      attrs=[
        View.attr("data-slot", dataSlot),
        Internal.flag("data-open", isOpen),
        Internal.flag("data-closed", () => !isOpen()),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      {Internal.Context.provide(itemContext, itemCtx, children)}
    </div>
  }
}

module Header = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="accordion-header",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) =>
    <h3 id=?{id} class=?{className} style=?{style} attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </h3>
}

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="accordion-trigger",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let item = Internal.Context.use(itemContext)
    let elementId = switch (id, item) {
    | (Some(id), _) => Some(id)
    | (None, Some({triggerId})) => Some(triggerId)
    | (None, None) => None
    }
    let disabled = disabled || item->Option.mapOr(false, item => item.disabled)
    let isOpen = () => item->Option.mapOr(false, item => item.isOpen())

    let activate = _ =>
      switch item {
      | Some({toggle}) if !disabled => toggle()
      | _ => ()
      }

    <button
      id=?{elementId}
      type_="button"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      ariaExpanded={isOpen}
      onClick={activate}
      attrs=[
        View.optionalAttr("aria-controls", item->Option.map(item => item.panelId)),
        View.optionalAttr("aria-disabled", disabled ? Some("true") : None),
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
    ~dataSlot: string="accordion-panel",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let item = Internal.Context.use(itemContext)
    let elementId = switch (id, item) {
    | (Some(id), _) => id
    | (None, Some({panelId})) => panelId
    | (None, None) => Internal.Id.make("accordion-panel")
    }
    let isOpen = item->Option.mapOr(() => true, item => item.isOpen)
    let panel = Internal.Panel.make(
      ~id=elementId,
      ~cssVariable="--accordion-panel-height",
      ~isOpen,
    )

    <div
      id={elementId}
      role="region"
      class=?{className}
      style=?{style}
      attrs=[
        View.optionalAttr("aria-labelledby", item->Option.map(item => item.triggerId)),
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
    ~value: option<MaybeSignal.t<array<string>>>=?,
    ~defaultValue: array<string>=[],
    ~onValueChange: option<array<string> => unit>=?,
    ~multiple: bool=false,
    ~disabled: bool=false,
    ~loopFocus: bool=true,
    ~orientation: Internal.Orientation.t=Vertical,
    ~dataSlot: string="accordion",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let state = Internal.Controlled.make(~value, ~defaultValue, ~onChange=onValueChange)

    let isOpen = itemValue => state.get()->Array.includes(itemValue)

    let toggle = itemValue => {
      let current = state.get()
      let next = if current->Array.includes(itemValue) {
        current->Array.filter(entry => entry !== itemValue)
      } else if multiple {
        Array.concat(current, [itemValue])
      } else {
        [itemValue]
      }
      state.set(next)
    }

    /* Roving focus across the triggers, matching Base UI's accordion keyboard
       behaviour. Read from the DOM so it keeps working for items rendered by a
       reactive list. */
    let onKeyDown = event => {
      let key = Internal.El.eventKey(event)
      let isNext = key === (orientation === Vertical ? "ArrowDown" : "ArrowRight")
      let isPrevious = key === (orientation === Vertical ? "ArrowUp" : "ArrowLeft")

      if isNext || isPrevious || key === "Home" || key === "End" {
        switch Internal.El.eventCurrentTarget(event)->Nullable.toOption {
        | None => ()
        | Some(root) =>
          let triggers =
            Internal.El.querySelectorAll(root, `[data-slot="accordion-trigger"]:not([disabled])`)
          let target = Internal.El.eventTarget(event)->Nullable.toOption
          let currentIndex =
            target->Option.flatMap(target =>
              triggers->Array.findIndexOpt(trigger => trigger->Internal.El.contains(target))
            )

          switch currentIndex {
          | None => ()
          | Some(index) =>
            let last = triggers->Array.length - 1
            let nextIndex = switch key {
            | "Home" => 0
            | "End" => last
            | _ if isNext => index === last ? (loopFocus ? 0 : last) : index + 1
            | _ => index === 0 ? (loopFocus ? last : 0) : index - 1
            }

            switch triggers->Array.get(nextIndex) {
            | Some(trigger) =>
              Internal.El.preventDefault(event)
              trigger->Internal.El.focus
            | None => ()
            }
          }
        }
      }
    }

    let ctx: Ctx.t = {isOpen, toggle, disabled, loopFocus}

    <div
      id=?{id}
      class=?{className}
      style=?{style}
      onKeyDown={onKeyDown}
      attrs=[
        View.attr("data-slot", dataSlot),
        View.attr("data-orientation", orientation->Internal.Orientation.toString),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      {Internal.Context.provide(context, ctx, children)}
    </div>
  }
}
