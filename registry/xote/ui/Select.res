@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = XoteBase.Anchored.Side
module Align = XoteBase.Anchored.Align

module Size = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("sm") Sm
}

@xote.component
let make = (
  ~value: option<MaybeSignal.t<string>>=?,
  ~defaultValue: string="",
  ~onValueChange: option<string => unit>=?,
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~placeholder: string="",
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Select.Root
    ?value defaultValue ?onValueChange ?open_ defaultOpen ?onOpenChange placeholder>
    {children}
  </XoteBase.Select.Root>

module Value = {
  @xote.component
  let make = (~className: option<string>=?) =>
    <XoteBase.Select.Value dataSlot="select-value" className={cn("", className)} />
}

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~size: Size.t=Default,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Select.Trigger
      ?id
      disabled
      ?ariaLabel
      dataSlot="select-trigger"
      dataSize={(size :> string)}
      className={cn(
        "cn-select-trigger flex w-fit items-center justify-between whitespace-nowrap outline-none disabled:cursor-not-allowed disabled:opacity-50 *:data-[slot=select-value]:line-clamp-1 *:data-[slot=select-value]:items-center [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}>
      {children}
      <Icons.ChevronDown className="size-4 opacity-50" />
    </XoteBase.Select.Trigger>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Bottom,
    ~align: Align.t=Start,
    ~sideOffset: float=4.,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Select.Positioner side align sideOffset>
      <XoteBase.Select.Popup
        ?id
        dataSlot="select-content"
        className={cn(
          "cn-select-content-logical cn-select-content cn-menu-target cn-menu-translucent relative isolate z-50 max-h-(--available-height) origin-(--transform-origin) overflow-x-hidden overflow-y-auto",
          className,
        )}>
        {children}
      </XoteBase.Select.Popup>
    </XoteBase.Select.Positioner>
}

module Item = {
  @xote.component
  let make = (
    ~value: string,
    ~label: option<string>=?,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Select.Item
      value
      ?label
      ?id
      disabled
      dataSlot="select-item"
      indicatorClassName="cn-select-item-indicator"
      indicator={<Icons.Check className="cn-select-item-indicator-icon pointer-events-none" />}
      className={cn(
        "cn-select-item relative flex w-full cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}>
      <span class="cn-select-item-text shrink-0 whitespace-nowrap"> {children} </span>
    </XoteBase.Select.Item>
}

module Label = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Label ?id dataSlot="select-label" className={cn("cn-select-label", className)}>
      {children}
    </XoteBase.Menu.Label>
}

module Separator = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <XoteBase.Menu.Separator
      ?id dataSlot="select-separator" className={cn("cn-select-separator pointer-events-none", className)}
    />
}

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Group ?className ?id dataSlot="select-group"> {children} </XoteBase.Menu.Group>
}
