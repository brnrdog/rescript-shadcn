/* A set of toggles sharing one selection: single-select behaves like a radio
   group, multiple lets any number be pressed. */

module Ctx = {
  type t = {
    isPressed: string => bool,
    toggle: string => unit,
    disabled: bool,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

module Item = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="toggle-group-item",
    ~dataVariant: option<string>=?,
    ~dataSize: option<string>=?,
    ~dataSpacing: option<string>=?,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let group = Internal.Context.use(context)
    let disabled = disabled || group->Option.mapOr(false, group => group.disabled)
    let isPressed = () => group->Option.mapOr(false, group => group.isPressed(value))

    let activate = _ =>
      switch group {
      | Some({toggle}) if !disabled => toggle(value)
      | _ => ()
      }

    <button
      id=?{id}
      type_="button"
      value
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      disabled
      onClick={activate}
      attrs=[
        Internal.boolAttr("aria-pressed", isPressed),
        Internal.flag("data-pressed", isPressed),
        Internal.flag("data-unpressed", () => !isPressed()),
        View.attr("data-slot", dataSlot),
        View.optionalAttr("data-variant", dataVariant),
        View.optionalAttr("data-size", dataSize),
        View.optionalAttr("data-spacing", dataSpacing),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      {children}
    </button>
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
    ~ariaLabel: option<string>=?,
    ~orientation: Internal.Orientation.t=Horizontal,
    ~dataSlot: string="toggle-group",
    ~dataVariant: option<string>=?,
    ~dataSize: option<string>=?,
    ~dataSpacing: option<string>=?,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let state = Internal.Controlled.make(~value, ~defaultValue, ~onChange=onValueChange)
    let orientationName = orientation->Internal.Orientation.toString

    let isPressed = item => state.get()->Array.includes(item)

    let toggle = item => {
      let current = state.get()
      let next = if current->Array.includes(item) {
        current->Array.filter(entry => entry !== item)
      } else if multiple {
        Array.concat(current, [item])
      } else {
        [item]
      }
      state.set(next)
    }

    <div
      id=?{id}
      role={multiple ? "group" : "radiogroup"}
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      attrs=[
        View.attr("data-slot", dataSlot),
        View.attr("data-orientation", orientationName),
        View.attr(`data-${orientationName}`, ""),
        View.optionalAttr("data-variant", dataVariant),
        View.optionalAttr("data-size", dataSize),
        View.optionalAttr("data-spacing", dataSpacing),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      {Internal.Context.provide(context, {isPressed, toggle, disabled}, children)}
    </div>
  }
}
