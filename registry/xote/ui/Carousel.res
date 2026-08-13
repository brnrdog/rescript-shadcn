@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Orientation = XoteBase.Internal.Orientation

/* Scroll-snap rather than a JS animation loop: the browser owns the motion, so
   there is no per-frame work and touch/trackpad gestures come for free. */
module Ctx = {
  type t = {
    viewportId: string,
    orientation: Orientation.t,
  }
}

let context: XoteBase.Internal.Context.t<Ctx.t> = XoteBase.Internal.Context.make()

let use = () => XoteBase.Internal.Context.use(context)

let scrollByPage: (Dom.element, int, bool) => unit = %raw(`function (el, direction, vertical) {
  const amount = (vertical ? el.clientHeight : el.clientWidth) * direction
  el.scrollBy({ [vertical ? "top" : "left"]: amount, behavior: "smooth" })
}`)

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~orientation: Orientation.t=Horizontal,
  ~ariaLabel: string="Carousel",
  ~children: View.node=View.fragment([]),
) => {
  let viewportId = XoteBase.Internal.Id.make("carousel-viewport")

  <div
    id=?{id}
    role="region"
    ariaLabel
    class={cn("cn-carousel relative", className)}
    attrs=[
      View.attr("data-slot", "carousel"),
      View.attr("data-orientation", orientation->Orientation.toString),
    ]>
    {XoteBase.Internal.Context.provide(context, {viewportId, orientation}, children)}
  </div>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) => {
    let ctx = use()
    let vertical = ctx->Option.mapOr(false, ctx => ctx.orientation === Vertical)

    <div
      id=?{ctx->Option.map(ctx => ctx.viewportId)}
      class={cn(
        `cn-carousel-content no-scrollbar flex snap-mandatory ${vertical
            ? "-mt-4 snap-y flex-col overflow-x-hidden overflow-y-auto"
            : "-ml-4 snap-x overflow-x-auto overflow-y-hidden"}`,
        className,
      )}
      attrs=[View.attr("data-slot", "carousel-content")]>
      {children}
    </div>
  }
}

module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) => {
    let vertical = use()->Option.mapOr(false, ctx => ctx.orientation === Vertical)

    <div
      id=?{id}
      role="group"
      class={cn(
        `cn-carousel-item min-w-0 shrink-0 grow-0 basis-full snap-start ${vertical
            ? "pt-4"
            : "pl-4"}`,
        className,
      )}
      attrs=[View.attr("data-slot", "carousel-item"), View.attr("aria-roledescription", "slide")]>
      {children}
    </div>
  }
}

let scrollButton = (~ctx: option<Ctx.t>, ~direction: int) => (_: Dom.event) =>
  switch ctx {
  | Some(ctx) =>
    switch XoteBase.Internal.El.getElementById(ctx.viewportId)->Nullable.toOption {
    | Some(viewport) => scrollByPage(viewport, direction, ctx.orientation === Vertical)
    | None => ()
    }
  | None => ()
  }

module Previous = {
  @xote.component
  let make = (~className: option<string>=?) => {
    let ctx = use()
    let vertical = ctx->Option.mapOr(false, ctx => ctx.orientation === Vertical)

    <Button
      variant=Outline
      size=IconSm
      ariaLabel="Previous slide"
      dataSlot="carousel-previous"
      className={cn(
        `cn-carousel-previous absolute touch-manipulation rounded-full ${vertical
            ? "-top-12 left-1/2 -translate-x-1/2 rotate-90"
            : "top-1/2 -left-12 -translate-y-1/2"}`,
        className,
      )}
      onClick={scrollButton(~ctx, ~direction=-1)}>
      <Icons.ChevronLeft />
    </Button>
  }
}

module Next = {
  @xote.component
  let make = (~className: option<string>=?) => {
    let ctx = use()
    let vertical = ctx->Option.mapOr(false, ctx => ctx.orientation === Vertical)

    <Button
      variant=Outline
      size=IconSm
      ariaLabel="Next slide"
      dataSlot="carousel-next"
      className={cn(
        `cn-carousel-next absolute touch-manipulation rounded-full ${vertical
            ? "-bottom-12 left-1/2 -translate-x-1/2 rotate-90"
            : "top-1/2 -right-12 -translate-y-1/2"}`,
        className,
      )}
      onClick={scrollButton(~ctx, ~direction=1)}>
      <Icons.ChevronRight />
    </Button>
  }
}
