module Status = {
  type t = Loading | Loaded | Failed
}

module Ctx = {
  type t = {
    status: Signal.t<Status.t>,
    hasImage: Signal.t<bool>,
  }
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
    let elementId = id->Option.getOr(Internal.Id.make("avatar-image"))
    let ctx = Internal.Context.use(context)

    switch ctx {
    | Some({hasImage}) => Signal.set(hasImage, true)
    | None => ()
    }

    let setStatus = status =>
      switch ctx {
      | Some({status: signal}) => Signal.set(signal, status)
      | None => ()
      }

    let isLoaded = () =>
      ctx->Option.mapOr(true, ctx => Signal.get(ctx.status) === Status.Loaded)

    Internal.Node.stateful(
      ~tag="img",
      ~id=elementId,
      ~attrs=[
        ("class", className),
        ("style", style),
        ("src", Some(src)),
        ("alt", Some(alt)),
        ("data-slot", Some(dataSlot)),
      ],
      /* The image stays in the tree while loading so the browser fetches it,
         but is hidden until it succeeds — the fallback owns the box until then. */
      ~state=() => [("hidden", isLoaded() ? None : Some(""))],
      ~events=[
        ("load", _ => setStatus(Status.Loaded)),
        ("error", _ => setStatus(Status.Failed)),
      ],
    )
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
    let elementId = id->Option.getOr(Internal.Id.make("avatar-fallback"))
    let ctx = Internal.Context.use(context)
    let isVisible = () =>
      ctx->Option.mapOr(true, ctx => Signal.get(ctx.status) !== Status.Loaded)

    Internal.Node.stateful(
      ~tag="span",
      ~id=elementId,
      ~attrs=[("class", className), ("style", style), ("data-slot", Some(dataSlot))],
      ~state=() => [("hidden", isVisible() ? None : Some(""))],
      ~children,
    )
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
    let elementId = id->Option.getOr(Internal.Id.make("avatar"))
    let ctx: Ctx.t = {
      status: Signal.make(Status.Loading),
      hasImage: Signal.make(false),
    }

    let inner = Internal.Context.provide(context, ctx, children)

    Internal.Node.make(
      ~tag="span",
      ~attrs=[
        ("id", Some(elementId)),
        ("class", className),
        ("style", style),
        ("data-slot", Some(dataSlot)),
        ("data-size", dataSize),
      ],
      ~children=inner,
    )
  }
}
