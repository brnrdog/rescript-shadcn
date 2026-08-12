@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("muted") Muted
    | @as("ghost") Ghost
    | @as("destructive") Destructive
}

module Align = {
  @unboxed
  type t =
    | @as("start") Start
    | @as("end") End
}

module Side = {
  @unboxed
  type t =
    | @as("top") Top
    | @as("bottom") Bottom
}

let variantClass = (~variant: Variant.t) => `cn-bubble-variant-${(variant :> string)}`

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~variant: Variant.t=Default,
  ~align: Align.t=Start,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    class={cn(
      `cn-bubble group/bubble relative flex w-fit min-w-0 flex-col ${variantClass(~variant)}`,
      className,
    )}
    attrs=[
      View.attr("data-slot", "bubble"),
      View.attr("data-variant", (variant :> string)),
      View.attr("data-align", (align :> string)),
    ]>
    {children}
  </div>

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~align: Align.t=Start,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-bubble-group flex min-w-0 flex-col", className)}
      attrs=[
        View.attr("data-slot", "bubble-group"),
        View.attr("data-align", (align :> string)),
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
        "cn-bubble-content w-fit max-w-full min-w-0 overflow-hidden wrap-break-word [button]:text-left [button,a]:transition-colors",
        className,
      )}
      attrs=[View.attr("data-slot", "bubble-content")]>
      {children}
    </div>
}

module Reactions = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Bottom,
    ~align: Align.t=End,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        `cn-bubble-reactions cn-bubble-reactions-side-${(side :> string)} cn-bubble-reactions-align-${(align :> string)}`,
        className,
      )}
      attrs=[
        View.attr("data-slot", "bubble-reactions"),
        View.attr("data-side", (side :> string)),
        View.attr("data-align", (align :> string)),
      ]>
      {children}
    </div>
}
