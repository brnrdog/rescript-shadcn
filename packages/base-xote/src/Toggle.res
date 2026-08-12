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
  let elementId = id->Option.getOr(Internal.Id.make("toggle"))
  let state = Internal.Controlled.make(
    ~value=pressed,
    ~defaultValue=defaultPressed,
    ~onChange=onPressedChange,
  )

  let toggle = _ =>
    if !disabled {
      state.set(!state.get())
    }

  Internal.Node.stateful(
    ~tag="button",
    ~id=elementId,
    ~attrs=[
      ("class", className),
      ("style", style),
      ("type", Some("button")),
      ("aria-label", ariaLabel),
      ("data-slot", Some(dataSlot)),
      ("data-variant", dataVariant),
      ("data-size", dataSize),
      ("disabled", disabled ? Some("") : None),
      ("data-disabled", disabled ? Some("") : None),
    ],
    ~state=() => {
      let pressed = state.get()
      [
        ("aria-pressed", Some(pressed ? "true" : "false")),
        ("data-pressed", pressed ? Some("") : None),
        ("data-unpressed", pressed ? None : Some("")),
      ]
    },
    ~events=[("click", toggle)],
    ~children,
  )
}
