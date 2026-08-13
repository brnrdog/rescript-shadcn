@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("secondary") Secondary
    | @as("muted") Muted
    | @as("tinted") Tinted
    | @as("outline") Outline
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
  let sideClass = (~side: Side.t) =>
    switch side {
    | Top => "cn-bubble-reactions-side-top"
    | Bottom => "cn-bubble-reactions-side-bottom"
    }

  let alignClass = (~align: Align.t) =>
    switch align {
    | Start => "cn-bubble-reactions-align-start"
    | End => "cn-bubble-reactions-align-end"
    }

  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Bottom,
    ~align: Align.t=End,
    ~role: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      role=?{role}
      ariaLabel=?{ariaLabel}
      class={cn(
        `cn-bubble-reactions absolute z-10 flex w-fit items-center justify-center ${sideClass(
            ~side,
          )} ${alignClass(~align)}`,
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
