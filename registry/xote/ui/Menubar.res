@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = XoteBase.Anchored.Side
module Align = XoteBase.Anchored.Align

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("destructive") Destructive
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    role="menubar"
    ariaLabel=?{ariaLabel}
    class={cn("cn-menubar flex items-center", className)}
    attrs=[View.attr("data-slot", "menubar")]>
    {children}
  </div>

/* Each menu in the bar owns its own open state. */
module Menu = {
  @xote.component
  let make = (
    ~open_: option<MaybeSignal.t<bool>>=?,
    ~defaultOpen: bool=false,
    ~onOpenChange: option<bool => unit>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Root ?open_ defaultOpen ?onOpenChange modal=false>
      {children}
    </XoteBase.Menu.Root>
}

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Trigger
      ?id
      disabled
      ?ariaLabel
      dataSlot="menubar-trigger"
      className={cn("cn-menubar-trigger flex items-center outline-hidden select-none", className)}>
      {children}
    </XoteBase.Menu.Trigger>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Bottom,
    ~align: Align.t=Start,
    ~sideOffset: float=4.,
    ~alignOffset: float=0.,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Positioner side align sideOffset alignOffset>
      <XoteBase.Menu.Popup
        ?id
        dataSlot="menubar-content"
        className={cn(
          "cn-menubar-content cn-menubar-content-logical cn-menu-target cn-menu-translucent z-50 max-h-(--available-height) origin-(--transform-origin) overflow-x-hidden overflow-y-auto outline-none data-closed:overflow-hidden",
          className,
        )}>
        {children}
      </XoteBase.Menu.Popup>
    </XoteBase.Menu.Positioner>
}

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Group ?className ?id dataSlot="menubar-group"> {children} </XoteBase.Menu.Group>
}

module Label = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~inset: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Label
      ?id
      dataSlot="menubar-label"
      dataInset=?{inset ? Some("true") : None}
      className={cn("cn-menubar-label", className)}>
      {children}
    </XoteBase.Menu.Label>
}

module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~variant: Variant.t=Default,
    ~onSelect: option<unit => unit>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Item
      ?id
      disabled
      ?onSelect
      dataSlot="menubar-item"
      dataVariant={(variant :> string)}
      className={cn(
        "cn-menubar-item group/menubar-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}>
      {children}
    </XoteBase.Menu.Item>
}

module CheckboxItem = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~checked: option<MaybeSignal.t<bool>>=?,
    ~defaultChecked: bool=false,
    ~onCheckedChange: option<bool => unit>=?,
    ~disabled: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.CheckboxItem
      ?id
      ?checked
      defaultChecked
      ?onCheckedChange
      disabled
      dataSlot="menubar-checkbox-item"
      indicatorClassName="cn-menubar-item-indicator pointer-events-none"
      indicator={<Icons.Check />}
      className={cn(
        "cn-menubar-checkbox-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}>
      {children}
    </XoteBase.Menu.CheckboxItem>
}

module RadioGroup = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~value: option<MaybeSignal.t<string>>=?,
    ~defaultValue: string="",
    ~onValueChange: option<string => unit>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.RadioGroup
      ?className ?id ?value defaultValue ?onValueChange dataSlot="menubar-radio-group">
      {children}
    </XoteBase.Menu.RadioGroup>
}

module RadioItem = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.RadioItem
      value
      ?id
      disabled
      dataSlot="menubar-radio-item"
      indicatorClassName="cn-menubar-item-indicator pointer-events-none"
      indicator={<Icons.Check />}
      className={cn(
        "cn-menubar-radio-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}>
      {children}
    </XoteBase.Menu.RadioItem>
}

module Separator = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <XoteBase.Menu.Separator
      ?id dataSlot="menubar-separator" className={cn("cn-menubar-separator -mx-1 my-1 h-px", className)}
    />
}

module Shortcut = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <span
      id=?{id}
      class={cn("cn-menubar-shortcut ml-auto", className)}
      attrs=[View.attr("data-slot", "menubar-shortcut")]>
      {children}
    </span>
}
