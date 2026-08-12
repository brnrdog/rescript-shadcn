module Ctx = {
  type t = {isChecked: unit => bool, disabled: bool}
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

module Thumb = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="switch-thumb",
    ~style: option<string>=?,
  ) => {
    let ctx = Internal.Context.use(context)
    let isChecked = switch ctx {
    | Some({isChecked}) => isChecked
    | None => () => false
    }

    <span
      id=?{id}
      class=?{className}
      style=?{style}
      attrs=[
        View.attr("data-slot", dataSlot),
        Internal.flag("data-checked", isChecked),
        Internal.flag("data-unchecked", () => !isChecked()),
      ]
    />
  }
}

module Root = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~name: option<string>=?,
    ~checked: option<MaybeSignal.t<bool>>=?,
    ~defaultChecked: bool=false,
    ~onCheckedChange: option<bool => unit>=?,
    ~disabled: bool=false,
    ~required: bool=false,
    ~readOnly: bool=false,
    ~ariaLabel: option<string>=?,
    ~ariaLabelledBy: option<string>=?,
    ~ariaInvalid: option<bool>=?,
    ~dataSlot: string="switch",
    ~dataSize: option<string>=?,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let state = Internal.Controlled.make(
      ~value=checked,
      ~defaultValue=defaultChecked,
      ~onChange=onCheckedChange,
    )

    let toggle = _ =>
      if !disabled && !readOnly {
        state.set(!state.get())
      }

    <button
      id=?{id}
      type_="button"
      role="switch"
      name=?{name}
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      disabled
      onClick={toggle}
      attrs=[
        Internal.boolAttr("aria-checked", state.get),
        Internal.flag("data-checked", state.get),
        Internal.flag("data-unchecked", () => !state.get()),
        View.optionalAttr("aria-labelledby", ariaLabelledBy),
        View.optionalAttr(
          "aria-invalid",
          ariaInvalid->Option.map(invalid => invalid ? "true" : "false"),
        ),
        View.optionalAttr("aria-required", required ? Some("true") : None),
        View.optionalAttr("aria-readonly", readOnly ? Some("true") : None),
        View.attr("data-slot", dataSlot),
        View.optionalAttr("data-size", dataSize),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
        View.optionalAttr("data-readonly", readOnly ? Some("") : None),
      ]>
      {Internal.Context.provide(context, {isChecked: state.get, disabled}, children)}
    </button>
  }
}
