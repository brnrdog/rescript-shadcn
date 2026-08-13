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
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~modal: bool=true,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Menu.Root ?open_ defaultOpen ?onOpenChange modal>
    {children}
  </XoteBase.Menu.Root>

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Trigger ?className ?id disabled ?ariaLabel dataSlot="dropdown-menu-trigger">
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
    ~dataSlot: string="dropdown-menu-content",
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Positioner side align sideOffset alignOffset>
      <XoteBase.Menu.Popup
        ?id
        dataSlot
        className={cn(
          "cn-dropdown-menu-content cn-dropdown-menu-content-logical cn-menu-target cn-menu-translucent z-50 max-h-(--available-height) origin-(--transform-origin) overflow-x-hidden overflow-y-auto outline-none data-closed:overflow-hidden",
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
    <XoteBase.Menu.Group ?className ?id dataSlot="dropdown-menu-group"> {children} </XoteBase.Menu.Group>
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
      dataSlot="dropdown-menu-label"
      dataInset=?{inset ? Some("true") : None}
      className={cn("cn-dropdown-menu-label", className)}>
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
      dataSlot="dropdown-menu-item"
      dataVariant={(variant :> string)}
      className={cn(
        "cn-dropdown-menu-item group/dropdown-menu-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
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
      dataSlot="dropdown-menu-checkbox-item"
      indicatorClassName="cn-dropdown-menu-item-indicator pointer-events-none"
      indicator={<Icons.Check />}
      className={cn(
        "cn-dropdown-menu-checkbox-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
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
      ?className ?id ?value defaultValue ?onValueChange dataSlot="dropdown-menu-radio-group">
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
      dataSlot="dropdown-menu-radio-item"
      indicatorClassName="cn-dropdown-menu-item-indicator pointer-events-none"
      indicator={<Icons.Check />}
      className={cn(
        "cn-dropdown-menu-radio-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}>
      {children}
    </XoteBase.Menu.RadioItem>
}

module Separator = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <XoteBase.Menu.Separator
      ?id dataSlot="dropdown-menu-separator" className={cn("cn-dropdown-menu-separator", className)}
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
      class={cn("cn-dropdown-menu-shortcut", className)}
      attrs=[View.attr("data-slot", "dropdown-menu-shortcut")]>
      {children}
    </span>
}

/* Submenus: the trigger is an item of the parent menu, and the panel opens to
   the side rather than below. */
module Sub = {
  @xote.component
  let make = (
    ~open_: option<MaybeSignal.t<bool>>=?,
    ~defaultOpen: bool=false,
    ~onOpenChange: option<bool => unit>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Sub ?open_ defaultOpen ?onOpenChange modal=false> {children} </XoteBase.Menu.Sub>
}

module SubTrigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~inset: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.SubTrigger
      ?id
      disabled
      dataSlot="dropdown-menu-sub-trigger"
      dataInset=?{inset ? Some("true") : None}
      className={cn(
        "cn-dropdown-menu-sub-trigger data-popup-open:bg-accent data-popup-open:text-accent-foreground flex cursor-default items-center outline-hidden select-none [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}>
      {children}
      <Icons.ChevronRight className="cn-rtl-flip ml-auto" />
    </XoteBase.Menu.SubTrigger>
}

module SubContent = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Right,
    ~align: Align.t=Start,
    ~sideOffset: float=0.,
    ~alignOffset: float=-3.,
    ~children: View.node=View.fragment([]),
  ) =>
    <Content
      ?id
      side
      align
      sideOffset
      alignOffset
      dataSlot="dropdown-menu-sub-content"
      className={cn("cn-dropdown-menu-sub-content w-auto", className)}>
      {children}
    </Content>
}

/* The base registries portal submenu content explicitly; here the positioner
   already does, so this is a pass-through kept for source compatibility. */
module Portal = {
  @xote.component
  let make = (~children: View.node=View.fragment([])) => children
}
