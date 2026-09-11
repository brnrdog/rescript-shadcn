/* Anchored positioning for the overlay primitives — popover, tooltip, hover
   card, menus. Overlay content is portaled to the end of `document.body`, so it
   is positioned against the trigger's viewport rect with `position: fixed`. */

module Side = {
  @unboxed
  type t =
    | @as("top") Top
    | @as("right") Right
    | @as("bottom") Bottom
    | @as("left") Left

  let toString = (side: t) => (side :> string)

  let fromString = (value: string): t =>
    switch value {
    | "top" => Top
    | "right" => Right
    | "left" => Left
    | _ => Bottom
    }
}

module Align = {
  @unboxed
  type t =
    | @as("start") Start
    | @as("center") Center
    | @as("end") End

  let toString = (align: t) => (align :> string)
}

/* Returns the side actually used, which differs from the requested one when the
   preferred side has no room. Also sets `--transform-origin`, which the shadcn
   styles scale the enter animation from. */
let place: (
  Dom.element,
  Dom.element,
  string,
  string,
  float,
  float,
) => string = %raw(`function (anchor, popup, side, align, sideOffset, alignOffset) {
  // Take the element out of flow *before* measuring it. A block-level div in
  // the portal is as wide as the body, and placing from that rect puts the
  // overlay in the wrong place and flips it for the wrong reason.
  popup.style.position = "fixed"
  popup.style.top = "0px"
  popup.style.left = "0px"
  popup.style.width = "max-content"
  popup.style.maxWidth = "100vw"

  const a = anchor.getBoundingClientRect()
  const p = popup.getBoundingClientRect()
  const vw = window.innerWidth
  const vh = window.innerHeight
  const margin = 8

  const fits = (candidate) => {
    switch (candidate) {
      case "top": return a.top - p.height - sideOffset >= margin
      case "bottom": return a.bottom + p.height + sideOffset <= vh - margin
      case "left": return a.left - p.width - sideOffset >= margin
      default: return a.right + p.width + sideOffset <= vw - margin
    }
  }

  const opposite = { top: "bottom", bottom: "top", left: "right", right: "left" }
  const resolved = fits(side) ? side : fits(opposite[side]) ? opposite[side] : side
  const clamp = (value, max) => Math.min(Math.max(margin, value), Math.max(margin, max))

  let top
  let left
  if (resolved === "top" || resolved === "bottom") {
    top = resolved === "top" ? a.top - p.height - sideOffset : a.bottom + sideOffset
    left =
      align === "start"
        ? a.left + alignOffset
        : align === "end"
          ? a.right - p.width - alignOffset
          : a.left + (a.width - p.width) / 2 + alignOffset
    left = clamp(left, vw - p.width - margin)
  } else {
    left = resolved === "left" ? a.left - p.width - sideOffset : a.right + sideOffset
    top =
      align === "start"
        ? a.top + alignOffset
        : align === "end"
          ? a.bottom - p.height - alignOffset
          : a.top + (a.height - p.height) / 2 + alignOffset
    top = clamp(top, vh - p.height - margin)
  }

  popup.style.top = Math.round(top) + "px"
  popup.style.left = Math.round(left) + "px"

  // The variables the shadcn classes read: an overlay that should match its
  // trigger's width, and one that should not outgrow the space it has.
  popup.style.setProperty("--anchor-width", Math.round(a.width) + "px")
  popup.style.setProperty("--available-width", Math.round(vw - margin * 2) + "px")
  popup.style.setProperty(
    "--available-height",
    Math.round(
      resolved === "top"
        ? a.top - sideOffset - margin
        : resolved === "bottom"
          ? vh - a.bottom - sideOffset - margin
          : vh - margin * 2,
    ) + "px",
  )
  popup.style.setProperty(
    "--transform-origin",
    resolved === "top"
      ? "bottom center"
      : resolved === "bottom"
        ? "top center"
        : resolved === "left"
          ? "right center"
          : "left center",
  )

  return resolved
}`)

/* The resolved side, so a popup and its arrow can style themselves from it.

   The signal is wrapped in a record on purpose: handing `Signal.t<_>` straight
   to the polymorphic `Context.t<'a>` crashes the compiler with
   `Fatal error: exception Not_found`. */
module Placement = {
  type t = {side: Signal.t<Side.t>}
}

let sideContext: Internal.Context.t<Placement.t> = Internal.Context.make()

let useSide = (): (unit => Side.t) => {
  let placement = Internal.Context.use(sideContext)
  () =>
    switch placement {
    | Some({side}) => Signal.get(side)
    | None => Side.Bottom
    }
}

module Positioner = {
  @xote.component
  let make = (
    ~anchorId: string,
    ~side: Side.t=Bottom,
    ~align: Align.t=Center,
    ~sideOffset: float=4.,
    ~alignOffset: float=0.,
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = Internal.Id.make("positioner")
    let resolvedSide = Signal.make(side)

    Internal.El.withElement(elementId, positioner =>
      switch Internal.El.getElementById(anchorId)->Nullable.toOption {
      | None => ()
      | Some(anchor) =>
        let update = () =>
          Signal.set(
            resolvedSide,
            place(
              anchor,
              positioner,
              side->Side.toString,
              align->Align.toString,
              sideOffset,
              alignOffset,
            )->Side.fromString,
          )

        update()

        /* Anything that moves the anchor moves the overlay with it. */
        let stopScroll = Internal.El.onWindow("scroll", update)
        let stopResize = Internal.El.onWindow("resize", update)
        Internal.El.ownDisposer({
          dispose: () => {
            stopScroll()
            stopResize()
          },
        })
      }
    )

    <div
      id={elementId}
      class=?{className}
      attrs=[
        View.optionalAttr("data-slot", dataSlot),
        View.computedAttr("data-side", () => Signal.get(resolvedSide)->Side.toString),
        View.attr("data-align", align->Align.toString),
      ]>
      {Internal.Context.provide(sideContext, {side: resolvedSide}, children)}
    </div>
  }
}
