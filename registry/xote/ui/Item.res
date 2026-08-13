@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("outline") Outline
    | @as("muted") Muted
}

module Size = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("sm") Sm
    | @as("xs") Xs
}

module MediaVariant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("icon") Icon
    | @as("image") Image
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~variant: Variant.t=Default,
  ~size: Size.t=Default,
  ~href: option<string>=?,
  ~children: View.node=View.fragment([]),
) => {
  let classes = cn(
    `cn-item w-full group/item focus-visible:border-ring focus-visible:ring-ring/50 flex items-center flex-wrap outline-none transition-colors duration-100 focus-visible:ring-[3px] [a]:transition-colors cn-item-variant-${(variant :> string)} cn-item-size-${(size :> string)}`,
    className,
  )
  let attributes = [
    View.attr("data-slot", "item"),
    View.attr("data-variant", (variant :> string)),
    View.attr("data-size", (size :> string)),
  ]

  switch href {
  | Some(href) => <a id=?{id} href class={classes} attrs={attributes}> {children} </a>
  | None => <div id=?{id} class={classes} attrs={attributes}> {children} </div>
  }
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
      role="list"
      class={cn("cn-item-group group/item-group flex w-full flex-col", className)}
      attrs=[View.attr("data-slot", "item-group")]>
      {children}
    </div>
}

module Media = {
  module Variant = MediaVariant

  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~variant: MediaVariant.t=Default,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        `cn-item-media flex shrink-0 items-center justify-center [&_svg]:pointer-events-none cn-item-media-variant-${(variant :> string)}`,
        className,
      )}
      attrs=[
        View.attr("data-slot", "item-media"),
        View.attr("data-variant", (variant :> string)),
      ]>
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
      class={cn(
        "cn-item-content flex flex-1 flex-col [&+[data-slot=item-content]]:flex-none",
        className,
      )}
      attrs=[View.attr("data-slot", "item-content")]>
      {children}
    </div>
}

module Title = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-item-title", className)}
      attrs=[View.attr("data-slot", "item-title")]>
      {children}
    </div>
}

module Description = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        "cn-item-description [&>a:hover]:text-primary line-clamp-2 font-normal [&>a]:underline [&>a]:underline-offset-4",
        className,
      )}
      attrs=[View.attr("data-slot", "item-description")]>
      {children}
    </div>
}

module Actions = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-item-actions flex items-center", className)}
      attrs=[View.attr("data-slot", "item-actions")]>
      {children}
    </div>
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
      class={cn("cn-item-header flex basis-full items-center justify-between", className)}
      attrs=[View.attr("data-slot", "item-header")]>
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
      class={cn("cn-item-footer flex basis-full items-center justify-between", className)}
      attrs=[View.attr("data-slot", "item-footer")]>
      {children}
    </div>
}

module Separator = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <Separator ?id dataSlot="item-separator" className={cn("cn-item-separator", className)} />
}
