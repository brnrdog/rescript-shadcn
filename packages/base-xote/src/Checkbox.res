module Ctx = {
  type t = {isChecked: unit => bool, disabled: bool}
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

module Indicator = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="checkbox-indicator",
    ~keepMounted: bool=false,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = Internal.Context.use(context)
    let isChecked = switch ctx {
    | Some({isChecked}) => isChecked
    | None => () => true
    }

    let indicator = Internal.Node.make(
      ~tag="span",
      ~attrs=[
        ("id", id),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
      ],
      ~reactiveAttrs=keepMounted
        ? [("data-checked", () => isChecked() ? "" : "false")]
        : [],
      ~children,
    )

    /* Base UI unmounts the indicator while unchecked; `keepMounted` keeps it in
       the tree so an exit animation can run. */
    keepMounted
      ? indicator
      : View.Show.make({when_: MaybeSignal.computed(isChecked), children: indicator})
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
    ~dataSlot: string="checkbox",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("checkbox"))
    let state = Internal.Controlled.make(
      ~value=checked,
      ~defaultValue=defaultChecked,
      ~onChange=onCheckedChange,
    )

    let toggle = _ =>
      if !disabled && !readOnly {
        state.set(!state.get())
      }

    let inner = Internal.Context.provide(context, {isChecked: state.get, disabled}, children)

    Internal.Node.stateful(
      ~tag="button",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("type", Some("button")),
        ("role", Some("checkbox")),
        ("name", name),
        ("aria-label", ariaLabel),
        ("aria-labelledby", ariaLabelledBy),
        ("aria-invalid", ariaInvalid->Option.map(invalid => invalid ? "true" : "false")),
        ("aria-required", required ? Some("true") : None),
        ("aria-readonly", readOnly ? Some("true") : None),
        ("data-slot", Some(dataSlot)),
        ("disabled", disabled ? Some("") : None),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~state=() => {
        let checked = state.get()
        [
          ("aria-checked", Some(checked ? "true" : "false")),
          ("data-checked", checked ? Some("") : None),
          ("data-unchecked", checked ? None : Some("")),
        ]
      },
      ~events=[("click", toggle)],
      ~children=inner,
    )
  }
}
