@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = BaseXote.Anchored.Side
module Align = BaseXote.Anchored.Align

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
  <BaseXote.Tooltip.Root ?open_ defaultOpen ?onOpenChange delay closeDelay role="dialog">
    {children}
  </BaseXote.Tooltip.Root>

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <BaseXote.Tooltip.Trigger ?className ?id ?ariaLabel dataSlot="hover-card-trigger">
      {children}
    </BaseXote.Tooltip.Trigger>
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
    <BaseXote.Tooltip.Positioner side align sideOffset alignOffset className="isolate z-50">
      <BaseXote.Tooltip.Popup
        ?id
        dataSlot="hover-card-content"
        className={cn(
          "cn-popover-content cn-popover-content-logical z-50 w-64 origin-(--transform-origin) outline-hidden",
          className,
        )}>
        {children}
      </BaseXote.Tooltip.Popup>
    </BaseXote.Tooltip.Positioner>
}
