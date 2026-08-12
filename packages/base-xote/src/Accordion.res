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

    let inner = Internal.Context.provide(itemContext, itemCtx, children)

    Internal.Node.stateful(
      ~tag="div",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~state=() => {
        let open_ = isOpen()
        [("data-open", open_ ? Some("") : None), ("data-closed", open_ ? None : Some(""))]
      },
      ~children=inner,
    )
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
    Internal.Node.make(
      ~tag="h3",
      ~attrs=[
        ("id", id),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
      ],
      ~children,
    )
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
    | (Some(id), _) => id
    | (None, Some({triggerId})) => triggerId
    | (None, None) => Internal.Id.make("accordion-trigger")
    }
    let disabled = disabled || item->Option.mapOr(false, item => item.disabled)

    let activate = _ =>
      switch item {
      | Some({toggle}) if !disabled => toggle()
      | _ => ()
      }

    Internal.Node.stateful(
      ~tag="button",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("type", Some("button")),
        ("aria-label", ariaLabel),
        ("aria-controls", item->Option.map(item => item.panelId)),
        ("aria-disabled", disabled ? Some("true") : None),
        ("data-slot", Some(dataSlot)),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~state=() => {
        let open_ = item->Option.mapOr(false, item => item.isOpen())
        [
          ("aria-expanded", Some(open_ ? "true" : "false")),
          ("data-panel-open", open_ ? Some("") : None),
          ("data-open", open_ ? Some("") : None),
          ("data-closed", open_ ? None : Some("")),
        ]
      },
      ~events=[("click", activate)],
      ~children,
    )
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

    Internal.Panel.bind(~id=elementId, ~cssVariable="--accordion-panel-height", ~isOpen)

    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", Some(elementId)),
        ("class", className),
        ("style", style),
        ("role", Some("region")),
        ("aria-labelledby", item->Option.map(item => item.triggerId)),
        ("data-slot", Some(dataSlot)),
        ...Signal.untrack(() => {
          let open_ = isOpen()
          [
            ("data-open", open_ ? Some("") : None),
            ("data-closed", open_ ? None : Some("")),
            ("hidden", open_ ? None : Some("")),
          ]
        }),
      ],
      ~children,
    )
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
    let elementId = id->Option.getOr(Internal.Id.make("accordion"))
    let state = Internal.Controlled.make(
      ~value,
      ~defaultValue,
      ~onChange=onValueChange,
    )

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
        switch Internal.El.getElementById(elementId)->Nullable.toOption {
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
    let inner = Internal.Context.provide(context, ctx, children)

    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", Some(elementId)),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
        ("data-orientation", Some(orientation->Internal.Orientation.toString)),
        ("data-disabled", disabled ? Some("") : None),
      ],
      ~events=[("keydown", onKeyDown)],
      ~children=inner,
    )
  }
}
