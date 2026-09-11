@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("separator") Separator
    | @as("border") Border
}

let variantClass = (~variant: Variant.t) =>
  switch variant {
  | Default => "cn-marker-variant-default"
  | Separator => "cn-marker-variant-separator"
  | Border => "cn-marker-variant-border"
  }

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~variant: Variant.t=Default,
  ~role: option<string>=?,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    role=?{role}
    ariaLabel=?{ariaLabel}
    class={cn(
      `cn-marker group/marker relative flex w-full items-center ${variantClass(~variant)}`,
      className,
    )}
    attrs=[
      View.attr("data-slot", "marker"),
      View.attr("data-variant", (variant :> string)),
    ]>
    {children}
  </div>

module Icon = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <span
      id=?{id}
      ariaHidden={true}
      class={cn("cn-marker-icon shrink-0", className)}
      attrs=[View.attr("data-slot", "marker-icon")]>
      {children}
    </span>
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
      class={cn("cn-marker-content min-w-0 wrap-break-word", className)}
      attrs=[View.attr("data-slot", "marker-content")]>
      {children}
    </div>
}
