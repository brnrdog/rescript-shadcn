@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("outline") Outline
}

module Size = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("sm") Sm
    | @as("lg") Lg
}

let toggleVariantClass = (~variant: Variant.t) =>
  switch variant {
  | Outline => "cn-toggle-variant-outline"
  | Default => "cn-toggle-variant-default"
  }

let toggleSizeClass = (~size: Size.t) =>
  switch size {
  | Sm => "cn-toggle-size-sm"
  | Lg => "cn-toggle-size-lg"
  | Default => "cn-toggle-size-default"
  }

let toggleVariants = (~variant=Variant.Default, ~size=Size.Default) => {
  let base = "cn-toggle group/toggle hover:bg-muted inline-flex items-center justify-center whitespace-nowrap outline-none focus-visible:ring-[3px] disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0"
  `${base} ${toggleVariantClass(~variant)} ${toggleSizeClass(~size)}`
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~pressed: option<MaybeSignal.t<bool>>=?,
  ~defaultPressed: bool=false,
  ~onPressedChange: option<bool => unit>=?,
  ~disabled: bool=false,
  ~ariaLabel: option<string>=?,
  ~variant: Variant.t=Default,
  ~size: Size.t=Default,
  ~children: View.node=View.fragment([]),
) =>
  <BaseXote.Toggle
    ?id
    ?pressed
    defaultPressed
    ?onPressedChange
    disabled
    ?ariaLabel
    dataSlot="toggle"
    dataVariant={(variant :> string)}
    dataSize={(size :> string)}
    className={cn(toggleVariants(~variant, ~size), className)}>
    {children}
  </BaseXote.Toggle>
