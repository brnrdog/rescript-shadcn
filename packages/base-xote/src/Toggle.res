@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~pressed: option<MaybeSignal.t<bool>>=?,
  ~defaultPressed: bool=false,
  ~onPressedChange: option<bool => unit>=?,
  ~disabled: bool=false,
  ~ariaLabel: option<string>=?,
  ~dataSlot: string="toggle",
  ~dataVariant: option<string>=?,
  ~dataSize: option<string>=?,
  ~style: option<string>=?,
  ~children: View.node=Internal.noChildren,
) => {
  let state = Internal.Controlled.make(
    ~value=pressed,
    ~defaultValue=defaultPressed,
    ~onChange=onPressedChange,
  )

  let toggle = _ =>
    if !disabled {
      state.set(!state.get())
    }

  <button
    id=?{id}
    type_="button"
    class=?{className}
    style=?{style}
    ariaLabel=?{ariaLabel}
    disabled
    onClick={toggle}
    attrs=[
      Internal.boolAttr("aria-pressed", state.get),
      Internal.flag("data-pressed", state.get),
      Internal.flag("data-unpressed", () => !state.get()),
      View.attr("data-slot", dataSlot),
      View.optionalAttr("data-variant", dataVariant),
      View.optionalAttr("data-size", dataSize),
      View.optionalAttr("data-disabled", disabled ? Some("") : None),
    ]>
    {children}
  </button>
}
