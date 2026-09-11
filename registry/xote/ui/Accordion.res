@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~value: option<MaybeSignal.t<array<string>>>=?,
  ~defaultValue: array<string>=[],
  ~onValueChange: option<array<string> => unit>=?,
  ~disabled: bool=false,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Accordion.Root
    ?id
    ?value
    defaultValue
    ?onValueChange
    disabled
    dataSlot="accordion"
    className={cn("cn-accordion flex w-full flex-col", className)}>
    {children}
  </XoteBase.Accordion.Root>

module Multiple = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~value: option<MaybeSignal.t<array<string>>>=?,
    ~defaultValue: array<string>=[],
    ~onValueChange: option<array<string> => unit>=?,
    ~disabled: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Accordion.Root
      ?id
      ?value
      defaultValue
      ?onValueChange
      disabled
      multiple=true
      dataSlot="accordion"
      className={cn("cn-accordion flex w-full flex-col", className)}>
      {children}
    </XoteBase.Accordion.Root>
}

module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~value: option<string>=?,
    ~disabled: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Accordion.Item
      ?id ?value disabled dataSlot="accordion-item" className={cn("cn-accordion-item", className)}>
      {children}
    </XoteBase.Accordion.Item>
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
    <XoteBase.Accordion.Header className="flex">
      <XoteBase.Accordion.Trigger
        ?id
        disabled
        ?ariaLabel
        dataSlot="accordion-trigger"
        className={cn(
          "cn-accordion-trigger group/accordion-trigger relative flex flex-1 items-start justify-between border border-transparent transition-all outline-none aria-disabled:pointer-events-none aria-disabled:opacity-50",
          className,
        )}>
        {children}
        <Icons.ChevronDown
          dataSlot="accordion-trigger-icon"
          className="cn-accordion-trigger-icon pointer-events-none shrink-0 group-aria-expanded/accordion-trigger:hidden"
        />
        <Icons.ChevronUp
          dataSlot="accordion-trigger-icon"
          className="cn-accordion-trigger-icon pointer-events-none hidden shrink-0 group-aria-expanded/accordion-trigger:inline"
        />
      </XoteBase.Accordion.Trigger>
    </XoteBase.Accordion.Header>
}

module Content = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <XoteBase.Accordion.Panel
      ?id dataSlot="accordion-content" className="cn-accordion-content overflow-hidden">
      <div
        class={cn(
          "cn-accordion-content-inner [&_a]:hover:text-foreground h-(--accordion-panel-height) data-ending-style:h-0 data-starting-style:h-0 [&_a]:underline [&_a]:underline-offset-3 [&_p:not(:last-child)]:mb-4",
          className,
        )}>
        {children}
      </div>
    </XoteBase.Accordion.Panel>
}
