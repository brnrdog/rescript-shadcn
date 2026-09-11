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
    <div id=?{id} class=?{className} style=?{style} attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </div>
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

    <div
      id=?{id}
      class=?{className}
      style={() =>
        switch percentage() {
        | Some(value) => `width: ${value->Float.toString}%`
        | None => "width: 100%"
        }}
      attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </div>
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
    <span id=?{id} class=?{className} attrs=[View.attr("data-slot", dataSlot)]> {children} </span>
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

    <span id=?{id} class=?{className} attrs=[View.attr("data-slot", dataSlot)]>
      {/* With no children the value renders itself, like Base UI's
          `Progress.Value`. */
      Internal.hasChildren(children) ? children : View.signalText(formatted)}
    </span>
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

    let isComplete = () => percentage()->Option.mapOr(false, percentage => percentage >= 100.)

    <div
      id=?{id}
      role="progressbar"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      attrs=[
        View.optionalAttr("aria-labelledby", ariaLabelledBy),
        View.attr("aria-valuemin", min->Float.toString),
        View.attr("aria-valuemax", max->Float.toString),
        View.optionalComputedAttr("aria-valuenow", () =>
          current()->Option.map(value => value->Float.toString)
        ),
        View.attr("data-slot", dataSlot),
        Internal.flag("data-indeterminate", () => current() === None),
        Internal.flag("data-complete", isComplete),
        Internal.flag("data-progressing", () => current() !== None && !isComplete()),
      ]>
      {Internal.Context.provide(context, {percentage, formatted}, children)}
    </div>
  }
}
