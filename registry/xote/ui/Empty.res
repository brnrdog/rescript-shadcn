@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("icon") Icon
}

let emptyMediaVariantClass = (~variant: Variant.t) =>
  switch variant {
  | Icon => "cn-empty-media-icon"
  | Default => "cn-empty-media-default"
  }

let emptyMediaVariants = (~variant=Variant.Default) => {
  let base = "cn-empty-media flex shrink-0 items-center justify-center [&_svg]:pointer-events-none [&_svg]:shrink-0"
  `${base} ${emptyMediaVariantClass(~variant)}`
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    class={cn(
      "cn-empty flex w-full min-w-0 flex-1 flex-col items-center justify-center text-center text-balance",
      className,
    )}
    attrs=[View.attr("data-slot", "empty")]>
    {children}
  </div>

module Header = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-empty-header flex max-w-sm flex-col items-center", className)}
      attrs=[View.attr("data-slot", "empty-header")]>
      {children}
    </div>
}

module Media = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~variant: Variant.t=Default,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(emptyMediaVariants(~variant), className)}
      attrs=[
        View.attr("data-slot", "empty-icon"),
        View.attr("data-variant", (variant :> string)),
      ]>
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
      class={cn("cn-empty-title cn-font-heading", className)}
      attrs=[View.attr("data-slot", "empty-title")]>
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
        "cn-empty-description text-muted-foreground [&>a:hover]:text-primary [&>a]:underline [&>a]:underline-offset-4",
        className,
      )}
      attrs=[View.attr("data-slot", "empty-description")]>
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
        "cn-empty-content flex w-full max-w-sm min-w-0 flex-col items-center text-balance",
        className,
      )}
      attrs=[View.attr("data-slot", "empty-content")]>
      {children}
    </div>
}
