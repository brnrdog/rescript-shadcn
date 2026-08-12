@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~disabled: bool=false,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Collapsible.Root
    ?className ?id ?open_ defaultOpen ?onOpenChange disabled dataSlot="collapsible">
    {children}
  </XoteBase.Collapsible.Root>

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Collapsible.Trigger
      ?className ?id disabled ?ariaLabel dataSlot="collapsible-trigger">
      {children}
    </XoteBase.Collapsible.Trigger>
}

module Content = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <XoteBase.Collapsible.Panel ?className ?id dataSlot="collapsible-content">
      {children}
    </XoteBase.Collapsible.Panel>
}
