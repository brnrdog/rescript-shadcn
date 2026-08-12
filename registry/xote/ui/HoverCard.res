@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = XoteBase.Anchored.Side
module Align = XoteBase.Anchored.Align

/* Same machinery as the tooltip, with a dialog role, a longer delay and card
   sized content. */
@xote.component
let make = (
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~delay: int=500,
  ~closeDelay: int=100,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Tooltip.Root ?open_ defaultOpen ?onOpenChange delay closeDelay role="dialog">
    {children}
  </XoteBase.Tooltip.Root>

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Tooltip.Trigger ?className ?id ?ariaLabel dataSlot="hover-card-trigger">
      {children}
    </XoteBase.Tooltip.Trigger>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Bottom,
    ~align: Align.t=Center,
    ~sideOffset: float=4.,
    ~alignOffset: float=0.,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Tooltip.Positioner side align sideOffset alignOffset className="isolate z-50">
      <XoteBase.Tooltip.Popup
        ?id
        dataSlot="hover-card-content"
        className={cn(
          "cn-popover-content cn-popover-content-logical z-50 w-64 origin-(--transform-origin) outline-hidden",
          className,
        )}>
        {children}
      </XoteBase.Tooltip.Popup>
    </XoteBase.Tooltip.Positioner>
}
