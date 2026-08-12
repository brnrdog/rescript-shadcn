module Ctx = {
  type t = {
    percentage: unit => option<float>,
    formatted: unit => string,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

module Track = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="progress-track",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) =>
    Internal.Node.make(
      ~tag="div",
      ~attrs=[
        ("id", id),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
      ],
      ~children,
    )
}

module Indicator = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="progress-indicator",
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = Internal.Context.use(context)
    let percentage = ctx->Option.mapOr(() => Some(0.), ctx => ctx.percentage)

    Internal.Node.make(
      ~tag="div",
      ~attrs=[("id", id), ("class", className), ("data-slot", Some(dataSlot))],
      ~reactiveAttrs=[
        (
          "style",
          () =>
            switch percentage() {
            | Some(value) => `width: ${value->Float.toString}%`
            | None => "width: 100%"
            },
        ),
      ],
      ~children,
    )
  }
}

module Label = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="progress-label",
    ~children: View.node=Internal.noChildren,
  ) =>
    Internal.Node.make(
      ~tag="span",
      ~attrs=[("id", id), ("class", className), ("data-slot", Some(dataSlot))],
      ~children,
    )
}

module Value = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="progress-value",
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = Internal.Context.use(context)
    let formatted = ctx->Option.mapOr(() => "", ctx => ctx.formatted)

    Internal.Node.make(
      ~tag="span",
      ~attrs=[("id", id), ("class", className), ("data-slot", Some(dataSlot))],
      /* With no children the value renders itself, like Base UI's
         `Progress.Value`. */
      ~children=Internal.hasChildren(children) ? children : View.signalText(formatted),
    )
  }
}

module Root = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    /* `None` renders an indeterminate progress bar, like Base UI. */
    ~value: option<MaybeSignal.t<option<float>>>=?,
    ~min: float=0.,
    ~max: float=100.,
    ~ariaLabel: option<string>=?,
    ~ariaLabelledBy: option<string>=?,
    ~dataSlot: string="progress",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("progress"))
    let current = () =>
      switch value {
      | Some(value) => MaybeSignal.get(value)
      | None => None
      }

    let percentage = () =>
      current()->Option.map(value => {
        let span = max -. min
        let ratio = span === 0. ? 0. : (value -. min) /. span
        Math.min(1., Math.max(0., ratio)) *. 100.
      })

    let formatted = () =>
      switch percentage() {
      | Some(value) => `${value->Math.round->Float.toString}%`
      | None => ""
      }

    let ctx: Ctx.t = {percentage, formatted}
    let inner = Internal.Context.provide(context, ctx, children)

    Internal.Node.stateful(
      ~tag="div",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("role", Some("progressbar")),
        ("aria-label", ariaLabel),
        ("aria-labelledby", ariaLabelledBy),
        ("aria-valuemin", Some(min->Float.toString)),
        ("aria-valuemax", Some(max->Float.toString)),
        ("data-slot", Some(dataSlot)),
      ],
      ~state=() => {
        let value = current()
        let complete = percentage()->Option.mapOr(false, percentage => percentage >= 100.)
        [
          ("aria-valuenow", value->Option.map(value => value->Float.toString)),
          ("data-indeterminate", value === None ? Some("") : None),
          ("data-complete", complete ? Some("") : None),
          ("data-progressing", value !== None && !complete ? Some("") : None),
        ]
      },
      ~children=inner,
    )
  }
}
