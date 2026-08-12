module Status = {
  type t = Loading | Loaded | Failed
}

module Ctx = {
  type t = {status: Signal.t<Status.t>}
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

module Image = {
  @xote.component
  let make = (
    ~src: string,
    ~alt: string="",
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="avatar-image",
    ~style: option<string>=?,
  ) => {
    let ctx = Internal.Context.use(context)

    let setStatus = status =>
      switch ctx {
      | Some({status: signal}) => Signal.set(signal, status)
      | None => ()
      }

    let isLoaded = () => ctx->Option.mapOr(true, ctx => Signal.get(ctx.status) === Status.Loaded)

    Internal.El.preloadImage(src, () => setStatus(Status.Loaded), () => setStatus(Status.Failed))

    /* The image is in the tree from the start so the browser can paint it the
       moment it resolves, but stays hidden until then — the fallback owns the
       box in the meantime. */
    <img
      id=?{id}
      src
      alt
      class=?{className}
      style=?{style}
      attrs=[
        View.attr("data-slot", dataSlot),
        View.optionalComputedAttr("hidden", () => isLoaded() ? None : Some("true")),
      ]
    />
  }
}

module Fallback = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="avatar-fallback",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = Internal.Context.use(context)
    let isVisible = () => ctx->Option.mapOr(true, ctx => Signal.get(ctx.status) !== Status.Loaded)

    <span
      id=?{id}
      class=?{className}
      style=?{style}
      attrs=[
        View.attr("data-slot", dataSlot),
        View.optionalComputedAttr("hidden", () => isVisible() ? None : Some("true")),
      ]>
      {children}
    </span>
  }
}

module Root = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="avatar",
    ~dataSize: option<string>=?,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx: Ctx.t = {status: Signal.make(Status.Loading)}

    <span
      id=?{id}
      class=?{className}
      style=?{style}
      attrs=[View.attr("data-slot", dataSlot), View.optionalAttr("data-size", dataSize)]>
      {Internal.Context.provide(context, ctx, children)}
    </span>
  }
}
