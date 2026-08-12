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
  <BaseXote.Collapsible.Root
    ?className ?id ?open_ defaultOpen ?onOpenChange disabled dataSlot="collapsible">
    {children}
  </BaseXote.Collapsible.Root>

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <BaseXote.Collapsible.Trigger
      ?className ?id disabled ?ariaLabel dataSlot="collapsible-trigger">
      {children}
    </BaseXote.Collapsible.Trigger>
}

module Content = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <BaseXote.Collapsible.Panel ?className ?id dataSlot="collapsible-content">
      {children}
    </BaseXote.Collapsible.Panel>
}
