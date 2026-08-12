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
        `cn-carousel-content flex snap-mandatory overflow-auto scrollbar-none ${vertical
            ? "snap-y flex-col"
            : "snap-x"}`,
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
  ) =>
    <div
      id=?{id}
      role="group"
      class={cn("cn-carousel-item min-w-0 shrink-0 grow-0 basis-full snap-start", className)}
      attrs=[View.attr("data-slot", "carousel-item"), View.attr("aria-roledescription", "slide")]>
      {children}
    </div>
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

    <Button
      variant=Outline
      size=IconSm
      ariaLabel="Previous slide"
      dataSlot="carousel-previous"
      className={cn("cn-carousel-previous absolute top-1/2 -left-4 -translate-y-1/2 rounded-full", className)}
      onClick={scrollButton(~ctx, ~direction=-1)}>
      <Icons.ChevronLeft />
    </Button>
  }
}

module Next = {
  @xote.component
  let make = (~className: option<string>=?) => {
    let ctx = use()

    <Button
      variant=Outline
      size=IconSm
      ariaLabel="Next slide"
      dataSlot="carousel-next"
      className={cn("cn-carousel-next absolute top-1/2 -right-4 -translate-y-1/2 rounded-full", className)}
      onClick={scrollButton(~ctx, ~direction=1)}>
      <Icons.ChevronRight />
    </Button>
  }
}
