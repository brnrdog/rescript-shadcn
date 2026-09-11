@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = {
  @unboxed
  type t =
    | @as("left") Left
    | @as("right") Right
}

module Ctx = {
  type t = {
    isOpen: unit => bool,
    setOpen: bool => unit,
  }
}

let context: XoteBase.Internal.Context.t<Ctx.t> = XoteBase.Internal.Context.make()

let use = () => XoteBase.Internal.Context.use(context)

module Provider = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~open_: option<MaybeSignal.t<bool>>=?,
    ~defaultOpen: bool=true,
    ~onOpenChange: option<bool => unit>=?,
    ~children: View.node=View.fragment([]),
  ) => {
    let state = XoteBase.Internal.Controlled.make(
      ~value=open_,
      ~defaultValue=defaultOpen,
      ~onChange=onOpenChange,
    )

    <div
      id=?{id}
      class={cn("cn-sidebar-wrapper group/sidebar-wrapper flex min-h-svh w-full", className)}
      attrs=[View.attr("data-slot", "sidebar-wrapper")]>
      {XoteBase.Internal.Context.provide(
        context,
        {isOpen: state.get, setOpen: state.set},
        children,
      )}
    </div>
  }
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~side: Side.t=Left,
  ~children: View.node=View.fragment([]),
) => {
  let ctx = use()
  let isOpen = () => ctx->Option.mapOr(true, ctx => ctx.isOpen())

  <div
    id=?{id}
    class={cn(
      "cn-sidebar bg-sidebar text-sidebar-foreground group/sidebar flex h-svh w-(--sidebar-width) flex-col transition-[width] duration-200 data-[state=collapsed]:w-0 data-[state=collapsed]:overflow-hidden [--sidebar-width:16rem]",
      className,
    )}
    attrs=[
      View.attr("data-slot", "sidebar"),
      View.attr("data-side", (side :> string)),
      View.computedAttr("data-state", () => isOpen() ? "expanded" : "collapsed"),
    ]>
    {children}
  </div>
}

module Trigger = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) => {
    let ctx = use()

    <Button
      ?id
      variant=Ghost
      size=IconSm
      ariaLabel="Toggle sidebar"
      dataSlot="sidebar-trigger"
      className={cn("cn-sidebar-trigger", className)}
      onClick={_ =>
        switch ctx {
        | Some({isOpen, setOpen}) => setOpen(!isOpen())
        | None => ()
        }}>
      <Icons.MoreHorizontal />
    </Button>
  }
}

module Inset = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <main
      id=?{id}
      class={cn("cn-sidebar-inset bg-background relative flex w-full flex-1 flex-col", className)}
      attrs=[View.attr("data-slot", "sidebar-inset")]>
      {children}
    </main>
}

module Header = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-sidebar-header flex flex-col gap-2 p-2", className)}
      attrs=[View.attr("data-slot", "sidebar-header")]>
      {children}
    </div>
}

module Footer = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-sidebar-footer mt-auto flex flex-col gap-2 p-2", className)}
      attrs=[View.attr("data-slot", "sidebar-footer")]>
      {children}
    </div>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-sidebar-content flex min-h-0 flex-1 flex-col gap-2 overflow-auto", className)}
      attrs=[View.attr("data-slot", "sidebar-content")]>
      {children}
    </div>
}

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-sidebar-group relative flex w-full min-w-0 flex-col p-2", className)}
      attrs=[View.attr("data-slot", "sidebar-group")]>
      {children}
    </div>
}

module GroupLabel = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        "cn-sidebar-group-label text-sidebar-foreground/70 flex h-8 shrink-0 items-center rounded-md px-2 text-xs font-medium",
        className,
      )}
      attrs=[View.attr("data-slot", "sidebar-group-label")]>
      {children}
    </div>
}

module GroupContent = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-sidebar-group-content w-full text-sm", className)}
      attrs=[View.attr("data-slot", "sidebar-group-content")]>
      {children}
    </div>
}

module Menu = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <ul
      id=?{id}
      class={cn("cn-sidebar-menu flex w-full min-w-0 flex-col gap-1", className)}
      attrs=[View.attr("data-slot", "sidebar-menu")]>
      {children}
    </ul>
}

module MenuItem = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <li
      id=?{id}
      class={cn("cn-sidebar-menu-item group/menu-item relative", className)}
      attrs=[View.attr("data-slot", "sidebar-menu-item")]>
      {children}
    </li>
}

module MenuButton = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~href: option<string>=?,
    ~active: bool=false,
    ~size: string="default",
    ~variant: string="default",
    ~onClick: option<Dom.event => unit>=?,
    ~children: View.node=View.fragment([]),
  ) => {
    let classes = cn(
      `cn-sidebar-menu-button cn-sidebar-menu-button-size-${size} cn-sidebar-menu-button-variant-${variant} flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left text-sm outline-none data-[active=true]:font-medium [&>svg]:size-4 [&>svg]:shrink-0`,
      className,
    )
    let attributes = [
      View.attr("data-slot", "sidebar-menu-button"),
      View.attr("data-size", size),
      View.optionalAttr("data-active", active ? Some("true") : None),
    ]

    switch href {
    | Some(href) => <a id=?{id} href class={classes} attrs={attributes}> {children} </a>
    | None =>
      <button id=?{id} type_="button" class={classes} onClick=?{onClick} attrs={attributes}>
        {children}
      </button>
    }
  }
}

module MenuBadge = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <span
      id=?{id}
      class={cn(
        "cn-sidebar-menu-badge text-sidebar-foreground ml-auto flex h-5 min-w-5 items-center justify-center rounded-md px-1 text-xs tabular-nums",
        className,
      )}
      attrs=[View.attr("data-slot", "sidebar-menu-badge")]>
      {children}
    </span>
}

module Separator = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <Separator
      ?id dataSlot="sidebar-separator" className={cn("cn-sidebar-separator mx-2 w-auto", className)}
    />
}

module Input = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~placeholder: option<string>=?,
  ) =>
    <Input ?id ?placeholder className={cn("cn-sidebar-input h-8 w-full", className)} />
}
