@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = XoteBase.Anchored.Side
module Align = XoteBase.Anchored.Align

@xote.component
let make = (
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~modal: bool=false,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Popover.Root ?open_ defaultOpen ?onOpenChange modal>
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
    <XoteBase.Popover.Trigger ?className ?id disabled ?ariaLabel dataSlot="popover-trigger">
      {children}
    </XoteBase.Popover.Trigger>
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
    <XoteBase.Popover.Positioner side align sideOffset alignOffset>
      <XoteBase.Popover.Popup
        ?id
        dataSlot="popover-content"
        className={cn(
          "cn-popover-content-logical cn-popover-content z-50 w-72 origin-(--transform-origin) outline-hidden",
          className,
        )}>
        {children}
      </XoteBase.Popover.Popup>
    </XoteBase.Popover.Positioner>
}

module Header = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-popover-header", className)}
      attrs=[View.attr("data-slot", "popover-header")]>
      {children}
    </div>
}

module Title = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Popover.Title
      ?id dataSlot="popover-title" className={cn("cn-popover-title", className)}>
      {children}
    </XoteBase.Popover.Title>
}

module Description = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Popover.Description
      ?id dataSlot="popover-description" className={cn("cn-popover-description", className)}>
      {children}
    </XoteBase.Popover.Description>
}

module Close = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Popover.Close ?className ?id ?ariaLabel dataSlot="popover-close">
      {children}
    </XoteBase.Popover.Close>
}
