@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Orientation = BaseXote.Internal.Orientation

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("line") Line
}

let tabsListVariants = (~variant=Variant.Default) => {
  let base = "cn-tabs-list group/tabs-list text-muted-foreground inline-flex w-fit items-center justify-center group-data-vertical/tabs:h-fit group-data-vertical/tabs:flex-col"
  let variantClass = switch variant {
  | Line => "cn-tabs-list-variant-line gap-1 bg-transparent"
  | Default => "cn-tabs-list-variant-default bg-muted"
  }
  `${base} ${variantClass}`
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~value: option<MaybeSignal.t<string>>=?,
  ~defaultValue: string="",
  ~onValueChange: option<string => unit>=?,
  ~orientation: Orientation.t=Horizontal,
  ~disabled: bool=false,
  ~children: View.node=View.fragment([]),
) =>
  <BaseXote.Tabs.Root
    ?id
    ?value
    defaultValue
    ?onValueChange
    orientation
    disabled
    dataSlot="tabs"
    className={cn("cn-tabs group/tabs flex data-horizontal:flex-col", className)}>
    {children}
  </BaseXote.Tabs.Root>

module List = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~variant: Variant.t=Default,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <BaseXote.Tabs.List
      ?id
      ?ariaLabel
      dataSlot="tabs-list"
      dataVariant={(variant :> string)}
      className={cn(tabsListVariants(~variant), className)}>
      {children}
    </BaseXote.Tabs.List>
}

module Trigger = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <BaseXote.Tabs.Tab
      value
      ?id
      disabled
      ?ariaLabel
      dataSlot="tabs-trigger"
      className={cn(
        "cn-tabs-trigger focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:outline-ring text-foreground/60 hover:text-foreground dark:text-muted-foreground dark:hover:text-foreground relative inline-flex h-[calc(100%-1px)] flex-1 items-center justify-center gap-1.5 rounded-md border border-transparent px-1.5 py-0.5 font-medium whitespace-nowrap transition-all group-data-vertical/tabs:w-full group-data-vertical/tabs:justify-start focus-visible:ring-[3px] focus-visible:outline-1 disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none aria-disabled:opacity-50 group-data-[variant=default]/tabs-list:data-active:shadow-sm group-data-[variant=line]/tabs-list:data-active:shadow-none [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4 group-data-[variant=line]/tabs-list:bg-transparent group-data-[variant=line]/tabs-list:data-active:bg-transparent dark:group-data-[variant=line]/tabs-list:data-active:border-transparent dark:group-data-[variant=line]/tabs-list:data-active:bg-transparent data-active:bg-background dark:data-active:text-foreground dark:data-active:border-input dark:data-active:bg-input/30 data-active:text-foreground after:bg-foreground after:absolute after:opacity-0 after:transition-opacity group-data-horizontal/tabs:after:inset-x-0 group-data-horizontal/tabs:after:bottom-[-5px] group-data-horizontal/tabs:after:h-0.5 group-data-vertical/tabs:after:inset-y-0 group-data-vertical/tabs:after:-right-1 group-data-vertical/tabs:after:w-0.5 group-data-[variant=line]/tabs-list:data-active:after:opacity-100",
        className,
      )}>
      {children}
    </BaseXote.Tabs.Tab>
}

module Content = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <BaseXote.Tabs.Panel
      value
      ?id
      dataSlot="tabs-content"
      className={cn("cn-tabs-content flex-1 outline-none", className)}>
      {children}
    </BaseXote.Tabs.Panel>
}
