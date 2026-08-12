@module("tailwind-merge")
external cn: (string, string, option<string>) => string = "twMerge"

@module("tailwind-merge")
external cn2: (string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("destructive") Destructive
}

let alertVariantClass = (~variant: Variant.t) =>
  switch variant {
  | Default => "cn-alert-variant-default"
  | Destructive => "cn-alert-variant-destructive"
  }

let base = "cn-alert group/alert relative w-full"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~variant: Variant.t=Default,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    role="alert"
    class={cn(base, alertVariantClass(~variant), className)}
    data={BaseXote.Attrs.data([("slot", "alert"), ("variant", (variant :> string))])}>
    {children}
  </div>

module Title = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn2(
        "cn-alert-title [&_a]:underline [&_a]:underline-offset-3 [&_a]:hover:text-foreground",
        className,
      )}
      data={BaseXote.Attrs.data([("slot", "alert-title")])}>
      {children}
    </div>
}

module Description = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn2(
        "cn-alert-description [&_a]:underline [&_a]:underline-offset-3 [&_a]:hover:text-foreground",
        className,
      )}
      data={BaseXote.Attrs.data([("slot", "alert-description")])}>
      {children}
    </div>
}

module Action = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn2("cn-alert-action", className)}
      data={BaseXote.Attrs.data([("slot", "alert-action")])}>
      {children}
    </div>
}
