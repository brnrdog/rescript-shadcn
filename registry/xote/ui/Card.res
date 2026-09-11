@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Size = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("sm") Sm
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~size: Size.t=Default,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    class={cn("cn-card group/card flex flex-col", className)}
    attrs=[View.attr("data-slot", "card"), View.attr("data-size", (size :> string))]>
    {children}
  </div>

module Header = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn(
        "cn-card-header group/card-header @container/card-header grid auto-rows-min items-start has-data-[slot=card-action]:grid-cols-[1fr_auto] has-data-[slot=card-description]:grid-rows-[auto_auto]",
        className,
      )}
      attrs=[View.attr("data-slot", "card-header")]>
      {children}
    </div>
}

module Title = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn("cn-card-title cn-font-heading", className)}
      attrs=[View.attr("data-slot", "card-title")]>
      {children}
    </div>
}

module Description = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn("cn-card-description", className)}
      attrs=[View.attr("data-slot", "card-description")]>
      {children}
    </div>
}

module Action = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn(
        "cn-card-action col-start-2 row-span-2 row-start-1 self-start justify-self-end",
        className,
      )}
      attrs=[View.attr("data-slot", "card-action")]>
      {children}
    </div>
}

module Content = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn("cn-card-content", className)}
      attrs=[View.attr("data-slot", "card-content")]>
      {children}
    </div>
}

module Footer = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn("cn-card-footer flex items-center", className)}
      attrs=[View.attr("data-slot", "card-footer")]>
      {children}
    </div>
}
