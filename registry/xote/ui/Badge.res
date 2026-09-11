@module("tailwind-merge")
external cn: (string, string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("secondary") Secondary
    | @as("destructive") Destructive
    | @as("outline") Outline
    | @as("ghost") Ghost
    | @as("link") Link
}

let badgeVariantClass = (~variant: Variant.t) =>
  switch variant {
  | Default => "cn-badge-variant-default"
  | Secondary => "cn-badge-variant-secondary"
  | Destructive => "cn-badge-variant-destructive"
  | Outline => "cn-badge-variant-outline"
  | Ghost => "cn-badge-variant-ghost"
  | Link => "cn-badge-variant-link"
  }

let base = "cn-badge group/badge inline-flex w-fit shrink-0 items-center justify-center overflow-hidden whitespace-nowrap focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 [&>svg]:pointer-events-none"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~variant: Variant.t=Default,
  ~dataIcon: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <span
    id=?{id}
    class={cn(base, badgeVariantClass(~variant), className)}
    attrs=[
      View.attr("data-slot", "badge"),
      View.attr("data-variant", (variant :> string)),
      View.optionalAttr("data-icon", dataIcon),
    ]>
    {children}
  </span>
