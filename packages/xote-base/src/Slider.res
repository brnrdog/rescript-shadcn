/* Slider with one or more thumbs: pointer drag on the control plus the
   arrow/Page/Home/End keys the slider pattern requires.

   With several thumbs the root is a group and each thumb is the slider, which
   is what the ARIA pattern asks for — a thumb carries its own value and is
   bounded by its neighbours so they cannot cross. */

module Ctx = {
  type t = {
    values: unit => array<float>,
    setAt: (int, float) => unit,
    min: float,
    max: float,
    step: float,
    orientation: Internal.Orientation.t,
    disabled: bool,
    ariaLabel: option<string>,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

let use = () => Internal.Context.use(context)

let percentageOf = (value, ~min, ~max) => {
  let span = max -. min
  span === 0. ? 0. : (value -. min) /. span *. 100.
}

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
    let vertical = ctx->Option.mapOr(false, ctx => ctx.orientation === Vertical)

    /* One thumb fills from the start of the track; several fill the span
       between the outermost two. */
    let bounds = () =>
      switch ctx {
      | None => (0., 0.)
      | Some(ctx) =>
        let values = ctx.values()
        let lowest = values->Array.reduce(ctx.max, Math.min)
        let highest = values->Array.reduce(ctx.min, Math.max)
        let start = values->Array.length <= 1 ? ctx.min : lowest
        (
          percentageOf(start, ~min=ctx.min, ~max=ctx.max),
          percentageOf(highest, ~min=ctx.min, ~max=ctx.max),
        )
      }

    <div
      id=?{id}
      class=?{className}
      style={() => {
        let (start, end) = bounds()
        let offset = `${start->Float.toString}%`
        let size = `${(end -. start)->Float.toString}%`
        vertical
          ? `position: absolute; bottom: ${offset}; height: ${size}`
          : `position: absolute; left: ${offset}; width: ${size}`
      }}
      attrs=[View.attr("data-slot", dataSlot)]
    />
  }
}

module Thumb = {
  @xote.component
  let make = (
    ~index: int=0,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="slider-thumb",
  ) => {
    let ctx = use()
    let vertical = ctx->Option.mapOr(false, ctx => ctx.orientation === Vertical)
    let disabled = ctx->Option.mapOr(false, ctx => ctx.disabled)

    let current = () =>
      switch ctx {
      | Some(ctx) => ctx.values()->Array.get(index)->Option.getOr(ctx.min)
      | None => 0.
      }

    /* A thumb may not pass the ones either side of it. */
    let lowerBound = () =>
      switch ctx {
      | Some(ctx) => ctx.values()->Array.get(index - 1)->Option.getOr(ctx.min)
      | None => 0.
      }

    let upperBound = () =>
      switch ctx {
      | Some(ctx) => ctx.values()->Array.get(index + 1)->Option.getOr(ctx.max)
      | None => 0.
      }

    let onKeyDown = event =>
      switch ctx {
      | Some(ctx) if !ctx.disabled =>
        let value = current()
        let next = switch Internal.El.eventKey(event) {
        | "ArrowRight" | "ArrowUp" => Some(value +. ctx.step)
        | "ArrowLeft" | "ArrowDown" => Some(value -. ctx.step)
        | "PageUp" => Some(value +. ctx.step *. 10.)
        | "PageDown" => Some(value -. ctx.step *. 10.)
        | "Home" => Some(ctx.min)
        | "End" => Some(ctx.max)
        | _ => None
        }

        switch next {
        | Some(next) =>
          Internal.El.preventDefault(event)
          ctx.setAt(index, next)
        | None => ()
        }
      | _ => ()
      }

    <div
      id=?{id}
      role="slider"
      tabIndex={disabled ? -1 : 0}
      class=?{className}
      ariaLabel=?{ariaLabel->Option.orElse(ctx->Option.flatMap(ctx => ctx.ariaLabel))}
      onKeyDown={onKeyDown}
      style={() => {
        let offset = switch ctx {
        | Some(ctx) => `${percentageOf(current(), ~min=ctx.min, ~max=ctx.max)->Float.toString}%`
        | None => "0%"
        }
        vertical
          ? `position: absolute; bottom: ${offset}; transform: translateY(50%)`
          : `position: absolute; left: ${offset}; transform: translateX(-50%)`
      }}
      attrs=[
        View.computedAttr("aria-valuenow", () => current()->Float.toString),
        View.computedAttr("aria-valuemin", () => lowerBound()->Float.toString),
        View.computedAttr("aria-valuemax", () => upperBound()->Float.toString),
        View.attr("data-slot", dataSlot),
        View.attr("data-index", index->Int.toString),
        View.optionalAttr("aria-disabled", disabled ? Some("true") : None),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]
    />
  }
}

/* One thumb per value, so the markup follows the values it was given.

   `View.For` runs its render callback when the list is evaluated, which is
   outside the scope the context was provided in — so each thumb is wrapped in
   the context captured here, where it is still in scope. */
module Thumbs = {
  @xote.component
  let make = (~className: option<string>=?, ~dataSlot: string="slider-thumb") => {
    let ctx = use()
    let indexes = () =>
      switch ctx {
      | Some(ctx) => ctx.values()->Array.mapWithIndex((_, index) => index)
      | None => []
      }

    <View.For
      each={MaybeSignal.computed(indexes)}
      by={index => index->Int.toString}
      render={index =>
        switch ctx {
        | Some(ctx) =>
          Internal.Context.provide(context, ctx, <Thumb index ?className dataSlot />)
        | None => <Thumb index ?className dataSlot />
        }}
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
    ~value: option<MaybeSignal.t<array<float>>>=?,
    ~defaultValue: array<float>=[0.],
    ~onValueChange: option<array<float> => unit>=?,
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

    let clamp = (value, ~low, ~high) => Math.min(high, Math.max(low, value))

    let snap = value => {
      let steps = (value -. min) /. step
      min +. Math.round(steps) *. step
    }

    let setAt = (index, next) => {
      let values = state.get()
      let low = values->Array.get(index - 1)->Option.getOr(min)
      let high = values->Array.get(index + 1)->Option.getOr(max)
      let bounded = clamp(snap(next), ~low=Math.max(min, low), ~high=Math.min(max, high))

      switch values->Array.get(index) {
      | Some(current) if current === bounded => ()
      | None => ()
      | Some(_) =>
        let updated = values->Array.copy
        updated->Array.set(index, bounded)
        state.set(updated)
      }
    }

    /* Pressing the track moves whichever thumb is closest to the press. */
    let nearestIndex = value =>
      state
      .get()
      ->Array.reduceWithIndex((0, infinity), ((bestIndex, bestDistance), entry, index) => {
        let distance = Math.abs(entry -. value)
        distance < bestDistance ? (index, distance) : (bestIndex, bestDistance)
      })
      ->Pair.first

    let dragging = ref(None)

    let valueFromEvent = event =>
      switch Internal.El.eventCurrentTarget(event)->Nullable.toOption {
      | Some(control) => Some(min +. ratioFromEvent(control, event, vertical) *. (max -. min))
      | None => None
      }

    let onPointerDown = event =>
      if !disabled {
        switch valueFromEvent(event) {
        | Some(value) =>
          let index = nearestIndex(value)
          dragging := Some(index)
          switch Internal.El.eventCurrentTarget(event)->Nullable.toOption {
          | Some(control) => setPointerCapture(control, event)
          | None => ()
          }
          setAt(index, value)
        | None => ()
        }
      }

    let onPointerMove = event =>
      switch (dragging.contents, valueFromEvent(event)) {
      | (Some(index), Some(value)) => setAt(index, value)
      | _ => ()
      }

    let onPointerUp = _ => dragging := None

    let orientationName = orientation->Internal.Orientation.toString

    <div
      id=?{id}
      role="group"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onPointerCancel={onPointerUp}
      attrs=[
        View.attr("aria-orientation", orientationName),
        View.optionalAttr("aria-disabled", disabled ? Some("true") : None),
        View.attr("data-slot", dataSlot),
        View.attr(`data-${orientationName}`, ""),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
        View.optionalAttr("data-name", name),
      ]>
      {Internal.Context.provide(
        context,
        {values: state.get, setAt, min, max, step, orientation, disabled, ariaLabel},
        children,
      )}
    </div>
  }
}
