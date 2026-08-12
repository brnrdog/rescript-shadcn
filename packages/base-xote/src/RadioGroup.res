module Ctx = {
  type t = {
    selected: unit => string,
    select: string => unit,
    disabled: bool,
    readOnly: bool,
    name: option<string>,
  }
}

module ItemCtx = {
  type t = {isChecked: unit => bool}
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()
let itemContext: Internal.Context.t<ItemCtx.t> = Internal.Context.make()

module Indicator = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="radio-group-indicator",
    ~keepMounted: bool=false,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let item = Internal.Context.use(itemContext)
    let isChecked = item->Option.mapOr(() => true, item => item.isChecked)

    let indicator = Internal.Node.make(
      ~tag="span",
      ~attrs=[
        ("id", id),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
      ],
      ~children,
    )

    keepMounted
      ? indicator
      : View.Show.make({when_: MaybeSignal.computed(isChecked), children: indicator})
  }
}

module Item = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~ariaLabelledBy: option<string>=?,
    ~ariaInvalid: option<bool>=?,
    ~dataSlot: string="radio-group-item",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("radio-group-item"))
    let group = Internal.Context.use(context)
    let disabled = disabled || group->Option.mapOr(false, group => group.disabled)
    let readOnly = group->Option.mapOr(false, group => group.readOnly)
    let isChecked = () => group->Option.mapOr(false, group => group.selected() === value)

    let select = _ =>
      switch group {
      | Some({select}) if !disabled && !readOnly => select(value)
      | _ => ()
      }

    let inner = Internal.Context.provide(itemContext, {isChecked: isChecked}, children)

    Internal.Node.stateful(
      ~tag="button",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("type", Some("button")),
        ("role", Some("radio")),
        ("value", Some(value)),
        ("name", group->Option.flatMap(group => group.name)),
        ("aria-label", ariaLabel),
        ("aria-labelledby", ariaLabelledBy),
        ("aria-invalid", ariaInvalid->Option.map(invalid => invalid ? "true" : "false")),
        ("data-slot", Some(dataSlot)),
        ("disabled", disabled ? Some("") : None),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~state=() => {
        let checked = isChecked()
        [
          ("aria-checked", Some(checked ? "true" : "false")),
          ("tabindex", Some(checked ? "0" : "-1")),
          ("data-checked", checked ? Some("") : None),
          ("data-unchecked", checked ? None : Some("")),
        ]
      },
      ~events=[("click", select)],
      ~children=inner,
    )
  }
}

module Root = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~name: option<string>=?,
    ~value: option<MaybeSignal.t<string>>=?,
    ~defaultValue: string="",
    ~onValueChange: option<string => unit>=?,
    ~disabled: bool=false,
    ~required: bool=false,
    ~readOnly: bool=false,
    ~ariaLabel: option<string>=?,
    ~ariaLabelledBy: option<string>=?,
    ~dataSlot: string="radio-group",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("radio-group"))
    let state = Internal.Controlled.make(~value, ~defaultValue, ~onChange=onValueChange)

    /* Arrow keys move between radios and select as they go, per the radio
       group pattern. */
    let onKeyDown = event => {
      let key = Internal.El.eventKey(event)
      let isNext = key === "ArrowDown" || key === "ArrowRight"
      let isPrevious = key === "ArrowUp" || key === "ArrowLeft"

      if isNext || isPrevious {
        switch Internal.El.getElementById(elementId)->Nullable.toOption {
        | None => ()
        | Some(root) =>
          let radios = Internal.El.querySelectorAll(root, `[role="radio"]:not([disabled])`)
          let target = Internal.El.eventTarget(event)->Nullable.toOption
          switch target->Option.flatMap(target =>
            radios->Array.findIndexOpt(radio => radio->Internal.El.contains(target))
          ) {
          | None => ()
          | Some(index) =>
            let last = radios->Array.length - 1
            let nextIndex = isNext
              ? index === last ? 0 : index + 1
              : index === 0 ? last : index - 1
            switch radios->Array.get(nextIndex) {
            | Some(radio) =>
              Internal.El.preventDefault(event)
              radio->Internal.El.focus
              radio->Internal.El.click
            | None => ()
            }
          }
        }
      }
    }

    let ctx: Ctx.t = {
      selected: state.get,
      select: state.set,
      disabled,
      readOnly,
      name,
    }

    let inner = Internal.Context.provide(context, ctx, children)

    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", Some(elementId)),
        ("class", className),
        ("style", style),
        ("role", Some("radiogroup")),
        ("aria-label", ariaLabel),
        ("aria-labelledby", ariaLabelledBy),
        ("aria-required", required ? Some("true") : None),
        ("aria-readonly", readOnly ? Some("true") : None),
        ("data-slot", Some(dataSlot)),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~events=[("keydown", onKeyDown)],
      ~children=inner,
    )
  }
}
