@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Variant = Toggle.Variant
module Size = Toggle.Size
module Orientation = XoteBase.Internal.Orientation

/* Items inherit the group's variant, size and spacing the way the React
   registries do through context. */
module Ctx = {
  type t = {
    variant: Variant.t,
    size: Size.t,
    spacing: float,
  }
}

let context: XoteBase.Internal.Context.t<Ctx.t> = XoteBase.Internal.Context.make()

let use = () => XoteBase.Internal.Context.use(context)

/* Providing from inside the root's children — rather than around them — keeps
   the root's own context in place while this one is read. */
module Provider = {
  @xote.component
  let make = (
    ~variant: Variant.t,
    ~size: Size.t,
    ~spacing: float,
    ~children: View.node=View.fragment([]),
  ) => XoteBase.Internal.Context.provide(context, {variant, size, spacing}, children)
}

let spacingValue = (spacing: float) =>
  spacing === Float.fromInt(spacing->Float.toInt)
    ? spacing->Float.toInt->Int.toString
    : spacing->Float.toString

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~value: option<MaybeSignal.t<array<string>>>=?,
  ~defaultValue: array<string>=[],
  ~onValueChange: option<array<string> => unit>=?,
  ~multiple: bool=false,
  ~disabled: bool=false,
  ~ariaLabel: option<string>=?,
  ~orientation: Orientation.t=Horizontal,
  ~variant: Variant.t=Default,
  ~size: Size.t=Default,
  ~spacing: float=2.,
  ~children: View.node=View.fragment([]),
) => {
  let spacingText = spacingValue(spacing)

  <XoteBase.ToggleGroup.Root
    dataSpacing={spacingText}
    style={`--gap: ${spacingText}`}
    ?id
    ?value
    defaultValue
    ?onValueChange
    multiple
    disabled
    ?ariaLabel
    orientation
    dataSlot="toggle-group"
    dataVariant={(variant :> string)}
    dataSize={(size :> string)}
    className={cn(
      "cn-toggle-group group/toggle-group flex w-fit flex-row items-center gap-[--spacing(var(--gap))] data-vertical:flex-col data-vertical:items-stretch",
      className,
    )}>
    <Provider variant size spacing> {children} </Provider>
  </XoteBase.ToggleGroup.Root>
}

module Item = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~variant: Variant.t=Default,
    ~size: Size.t=Default,
    ~children: View.node=View.fragment([]),
  ) => {
    let group = use()
    let variant = group->Option.mapOr(variant, group => group.variant)
    let size = group->Option.mapOr(size, group => group.size)

    <XoteBase.ToggleGroup.Item
      value
      ?id
      disabled
      ?ariaLabel
      dataSlot="toggle-group-item"
      dataVariant={(variant :> string)}
      dataSize={(size :> string)}
      dataSpacing=?{group->Option.map(group => spacingValue(group.spacing))}
      className={cn(
        `cn-toggle-group-item shrink-0 group-data-[spacing=0]/toggle-group:rounded-none group-data-[spacing=0]/toggle-group:px-2 focus:z-10 focus-visible:z-10 group-data-horizontal/toggle-group:data-[spacing=0]:first:rounded-l-lg group-data-vertical/toggle-group:data-[spacing=0]:first:rounded-t-lg group-data-horizontal/toggle-group:data-[spacing=0]:last:rounded-r-lg group-data-vertical/toggle-group:data-[spacing=0]:last:rounded-b-lg group-data-horizontal/toggle-group:data-[spacing=0]:data-[variant=outline]:border-l-0 group-data-vertical/toggle-group:data-[spacing=0]:data-[variant=outline]:border-t-0 group-data-horizontal/toggle-group:data-[spacing=0]:data-[variant=outline]:first:border-l group-data-vertical/toggle-group:data-[spacing=0]:data-[variant=outline]:first:border-t ${Toggle.toggleVariants(
          ~variant,
          ~size,
        )}`,
        className,
      )}>
      {children}
    </XoteBase.ToggleGroup.Item>
  }
}
