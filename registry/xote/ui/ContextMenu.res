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
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.ContextTrigger
      ?id
      disabled
      dataSlot="context-menu-trigger"
      className={cn("cn-context-menu-trigger select-none", className)}>
      {children}
    </XoteBase.Menu.ContextTrigger>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Right,
    ~align: Align.t=Start,
    ~sideOffset: float=0.,
    ~alignOffset: float=4.,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Positioner side align sideOffset alignOffset>
      <XoteBase.Menu.Popup
        ?id
        dataSlot="context-menu-content"
        className={cn(
          "cn-context-menu-content cn-context-menu-content-logical cn-menu-target cn-menu-translucent z-50 max-h-(--available-height) origin-(--transform-origin) overflow-x-hidden overflow-y-auto outline-none data-closed:overflow-hidden",
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
    <XoteBase.Menu.Group ?className ?id dataSlot="context-menu-group"> {children} </XoteBase.Menu.Group>
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
      dataSlot="context-menu-label"
      dataInset=?{inset ? Some("true") : None}
      className={cn("cn-context-menu-label", className)}>
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
      dataSlot="context-menu-item"
      dataVariant={(variant :> string)}
      className={cn(
        "cn-context-menu-item group/context-menu-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
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
      dataSlot="context-menu-checkbox-item"
      indicatorClassName="cn-context-menu-item-indicator pointer-events-none"
      indicator={<Icons.Check />}
      className={cn(
        "cn-context-menu-checkbox-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
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
      ?className ?id ?value defaultValue ?onValueChange dataSlot="context-menu-radio-group">
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
      dataSlot="context-menu-radio-item"
      indicatorClassName="cn-context-menu-item-indicator pointer-events-none"
      indicator={<Icons.Check />}
      className={cn(
        "cn-context-menu-radio-item relative flex cursor-default items-center outline-hidden select-none data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}>
      {children}
    </XoteBase.Menu.RadioItem>
}

module Separator = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <XoteBase.Menu.Separator
      ?id dataSlot="context-menu-separator" className={cn("cn-context-menu-separator", className)}
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
      class={cn("cn-context-menu-shortcut", className)}
      attrs=[View.attr("data-slot", "context-menu-shortcut")]>
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
      dataSlot="context-menu-sub-trigger"
      dataInset=?{inset ? Some("true") : None}
      className={cn("cn-context-menu-sub-trigger flex cursor-default items-center outline-hidden select-none data-[popup-open]:bg-accent [&_svg]:pointer-events-none [&_svg]:shrink-0", className)}>
      {children}
      <Icons.ChevronRight className="ml-auto size-4" />
    </XoteBase.Menu.SubTrigger>
}

module SubContent = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~sideOffset: float=0.,
    ~alignOffset: float=4.,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Positioner side=Right align=Start sideOffset alignOffset>
      <XoteBase.Menu.Popup
        ?id dataSlot="context-menu-subcontent" className={cn("cn-context-menu-subcontent cn-context-menu-content-logical cn-menu-target cn-menu-translucent z-50 min-w-32 origin-(--transform-origin) overflow-hidden outline-none", className)}>
        {children}
      </XoteBase.Menu.Popup>
    </XoteBase.Menu.Positioner>
}

/* The base registries portal submenu content explicitly; here the positioner
   already does, so this is a pass-through kept for source compatibility. */
module Portal = {
  @xote.component
  let make = (~children: View.node=View.fragment([])) => children
}
