@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = XoteBase.Anchored.Side
module Align = XoteBase.Anchored.Align

@xote.component
let make = (
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~delay: int=150,
  ~closeDelay: int=0,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Tooltip.Root ?open_ defaultOpen ?onOpenChange delay closeDelay>
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
    <XoteBase.Tooltip.Trigger ?className ?id ?ariaLabel dataSlot="tooltip-trigger">
      {children}
    </XoteBase.Tooltip.Trigger>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Top,
    ~align: Align.t=Center,
    ~sideOffset: float=4.,
    ~alignOffset: float=0.,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Tooltip.Positioner side align sideOffset alignOffset>
      <XoteBase.Tooltip.Popup
        ?id
        dataSlot="tooltip-content"
        className={cn(
          "cn-tooltip-content cn-tooltip-content-logical data-open:animate-in data-open:fade-in-0 data-open:zoom-in-95 data-closed:animate-out data-closed:fade-out-0 data-closed:zoom-out-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 bg-foreground text-background z-50 w-fit max-w-xs origin-(--transform-origin) rounded-md px-3 py-1.5 text-xs",
          className,
        )}>
        {children}
        <XoteBase.Tooltip.Arrow
          dataSlot="tooltip-arrow"
          className="cn-tooltip-arrow cn-tooltip-arrow-logical bg-foreground fill-foreground absolute z-50 data-[side=bottom]:top-1 data-[side=left]:top-1/2! data-[side=left]:-right-1 data-[side=left]:-translate-y-1/2 data-[side=right]:top-1/2! data-[side=right]:-left-1 data-[side=right]:-translate-y-1/2 data-[side=top]:-bottom-2.5"
        />
      </XoteBase.Tooltip.Popup>
    </XoteBase.Tooltip.Positioner>
}
