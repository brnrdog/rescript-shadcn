/* Single-thumb slider: pointer drag on the track plus the arrow/Home/End keys
   the slider pattern requires. */

module Ctx = {
  type t = {
    percentage: unit => float,
    orientation: Internal.Orientation.t,
    disabled: bool,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

let use = () => Internal.Context.use(context)

module Track = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="slider-track",
    ~children: View.node=Internal.noChildren,
  ) =>
    <div id=?{id} class=?{className} attrs=[View.attr("data-slot", dataSlot)]> {children} </div>
}

module Range = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="slider-range",
  ) => {
    let ctx = use()
    let percentage = ctx->Option.mapOr(() => 0., ctx => ctx.percentage)
    let vertical = ctx->Option.mapOr(false, ctx => ctx.orientation === Vertical)

    <div
      id=?{id}
      class=?{className}
      style={() => {
        let size = `${percentage()->Float.toString}%`
        vertical ? `height: ${size}` : `width: ${size}`
      }}
      attrs=[View.attr("data-slot", dataSlot)]
    />
  }
}

module Thumb = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="slider-thumb",
  ) => {
    let ctx = use()
    let percentage = ctx->Option.mapOr(() => 0., ctx => ctx.percentage)
    let vertical = ctx->Option.mapOr(false, ctx => ctx.orientation === Vertical)

    <div
      id=?{id}
      class=?{className}
      style={() => {
        let offset = `${percentage()->Float.toString}%`
        vertical
          ? `position: absolute; bottom: ${offset}; transform: translateY(50%)`
          : `position: absolute; left: ${offset}; transform: translateX(-50%)`
      }}
      attrs=[View.attr("data-slot", dataSlot)]
    />
  }
}

/* Where a pointer landed along the control, as a 0..1 ratio. */
let ratioFromEvent: (Dom.element, Dom.event, bool) => float = %raw(`function (el, event, vertical) {
  const rect = el.getBoundingClientRect()
  const ratio = vertical
    ? (rect.bottom - event.clientY) / rect.height
    : (event.clientX - rect.left) / rect.width
  return Math.min(1, Math.max(0, ratio))
}`)

let setPointerCapture: (Dom.element, Dom.event) => unit = %raw(`function (el, event) {
  if (event.pointerId !== undefined && el.setPointerCapture) { el.setPointerCapture(event.pointerId) }
}`)

module Root = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~name: option<string>=?,
    ~value: option<MaybeSignal.t<float>>=?,
    ~defaultValue: float=0.,
    ~onValueChange: option<float => unit>=?,
    ~min: float=0.,
    ~max: float=100.,
    ~step: float=1.,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~orientation: Internal.Orientation.t=Horizontal,
    ~dataSlot: string="slider",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let state = Internal.Controlled.make(~value, ~defaultValue, ~onChange=onValueChange)
    let vertical = orientation === Vertical

    let clamp = value => Math.min(max, Math.max(min, value))

    let snap = value => {
      let steps = (value -. min) /. step
      clamp(min +. Math.round(steps) *. step)
    }

    let percentage = () => {
      let span = max -. min
      span === 0. ? 0. : (state.get() -. min) /. span *. 100.
    }

    let commitFromEvent = event =>
      switch Internal.El.eventCurrentTarget(event)->Nullable.toOption {
      | Some(control) if !disabled =>
        state.set(snap(min +. ratioFromEvent(control, event, vertical) *. (max -. min)))
      | _ => ()
      }

    let dragging = ref(false)

    let onPointerDown = event =>
      if !disabled {
        dragging := true
        switch Internal.El.eventCurrentTarget(event)->Nullable.toOption {
        | Some(control) => setPointerCapture(control, event)
        | None => ()
        }
        commitFromEvent(event)
      }

    let onPointerMove = event =>
      if dragging.contents {
        commitFromEvent(event)
      }

    let onPointerUp = _ => dragging := false

    let onKeyDown = event => {
      if !disabled {
        let current = state.get()
        let next = switch Internal.El.eventKey(event) {
        | "ArrowRight" | "ArrowUp" => Some(clamp(current +. step))
        | "ArrowLeft" | "ArrowDown" => Some(clamp(current -. step))
        | "PageUp" => Some(clamp(current +. step *. 10.))
        | "PageDown" => Some(clamp(current -. step *. 10.))
        | "Home" => Some(min)
        | "End" => Some(max)
        | _ => None
        }

        switch next {
        | Some(next) =>
          Internal.El.preventDefault(event)
          state.set(next)
        | None => ()
        }
      }
    }

    let orientationName = orientation->Internal.Orientation.toString

    <div
      id=?{id}
      role="slider"
      tabIndex={disabled ? -1 : 0}
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onKeyDown={onKeyDown}
      attrs=[
        View.attr("aria-valuemin", min->Float.toString),
        View.attr("aria-valuemax", max->Float.toString),
        View.computedAttr("aria-valuenow", () => state.get()->Float.toString),
        View.attr("aria-orientation", orientationName),
        View.optionalAttr("aria-disabled", disabled ? Some("true") : None),
        View.attr("data-slot", dataSlot),
        View.attr(`data-${orientationName}`, ""),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
        View.optionalAttr("data-name", name),
      ]>
      {Internal.Context.provide(context, {percentage, orientation, disabled}, children)}
    </div>
  }
}
