@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = XoteBase.Anchored.Side
module Align = XoteBase.Anchored.Align

/* A popover holding a command list: the trigger shows the current selection,
   the list filters as you type. */
@xote.component
let make = (
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Popover.Root ?open_ defaultOpen ?onOpenChange>
    {children}
  </XoteBase.Popover.Root>

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Popover.Trigger
      ?id
      disabled
      ?ariaLabel
      dataSlot="combobox-trigger"
      className={cn(
        "cn-combobox-trigger flex w-full items-center justify-between whitespace-nowrap outline-none disabled:cursor-not-allowed disabled:opacity-50",
        className,
      )}>
      {children}
      <Icons.ChevronDown className="size-4 shrink-0 opacity-50" />
    </XoteBase.Popover.Trigger>
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
    <XoteBase.Popover.Positioner side align sideOffset>
      <XoteBase.Popover.Popup
        ?id
        dataSlot="combobox-content"
        className={cn(
          "cn-combobox-content cn-combobox-content-logical z-50 w-72 origin-(--transform-origin) overflow-hidden outline-hidden",
          className,
        )}>
        {children}
      </XoteBase.Popover.Popup>
    </XoteBase.Popover.Positioner>
}

module Input = Command.Input
module List = Command.List
module Empty = Command.Empty
module Group = Command.Group
module Item = Command.Item
module Separator = Command.Separator
