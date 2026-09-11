@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = {
  @unboxed
  type t =
    | @as("top") Top
    | @as("right") Right
    | @as("bottom") Bottom
    | @as("left") Left
}

@xote.component
let make = (
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~modal: bool=true,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Dialog.Root ?open_ defaultOpen ?onOpenChange modal>
    {children}
  </XoteBase.Dialog.Root>

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Trigger ?className ?id disabled ?ariaLabel dataSlot="sheet-trigger">
      {children}
    </XoteBase.Dialog.Trigger>
}

module Close = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Close ?className ?id ?ariaLabel dataSlot="sheet-close">
      {children}
    </XoteBase.Dialog.Close>
}

module Overlay = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <XoteBase.Dialog.Backdrop
      ?id
      dataSlot="sheet-overlay"
      className={cn(
        "cn-sheet-overlay data-open:animate-in data-closed:animate-out data-closed:fade-out-0 data-open:fade-in-0 fixed inset-0 z-50 duration-100 data-ending-style:opacity-0 data-starting-style:opacity-0",
        className,
      )}
    />
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Right,
    ~showCloseButton: bool=true,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Portal>
      <Overlay />
      <XoteBase.Dialog.Popup
        ?id
        dataSlot="sheet-content"
        attrs=[View.attr("data-side", (side :> string))]
        className={cn(
          "cn-sheet-content bg-background data-open:animate-in data-closed:animate-out data-[side=right]:data-closed:slide-out-to-right-10 data-[side=right]:data-open:slide-in-from-right-10 data-[side=left]:data-closed:slide-out-to-left-10 data-[side=left]:data-open:slide-in-from-left-10 data-[side=top]:data-closed:slide-out-to-top-10 data-[side=top]:data-open:slide-in-from-top-10 data-closed:fade-out-0 data-open:fade-in-0 data-[side=bottom]:data-closed:slide-out-to-bottom-10 data-[side=bottom]:data-open:slide-in-from-bottom-10 fixed z-50 flex flex-col gap-4 bg-clip-padding text-sm shadow-lg transition duration-200 ease-in-out data-[side=bottom]:inset-x-0 data-[side=bottom]:bottom-0 data-[side=bottom]:h-auto data-[side=bottom]:border-t data-[side=left]:inset-y-0 data-[side=left]:left-0 data-[side=left]:h-full data-[side=left]:w-3/4 data-[side=left]:border-r data-[side=right]:inset-y-0 data-[side=right]:right-0 data-[side=right]:h-full data-[side=right]:w-3/4 data-[side=right]:border-l data-[side=top]:inset-x-0 data-[side=top]:top-0 data-[side=top]:h-auto data-[side=top]:border-b data-[side=left]:sm:max-w-sm data-[side=right]:sm:max-w-sm",
          className,
        )}>
        {children}
        {showCloseButton
          ? <XoteBase.Dialog.Close
              dataSlot="sheet-close"
              className={Button.buttonVariants(
                ~variant=Ghost,
                ~size=IconSm,
                ~className="cn-sheet-close",
              )}>
              <Icons.X />
              <span class="sr-only"> {"Close"} </span>
            </XoteBase.Dialog.Close>
          : View.fragment([])}
      </XoteBase.Dialog.Popup>
    </XoteBase.Dialog.Portal>
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
      class={cn("cn-sheet-header flex flex-col", className)}
      attrs=[View.attr("data-slot", "sheet-header")]>
      {children}
    </div>
}

module Footer = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-sheet-footer mt-auto flex flex-col", className)}
      attrs=[View.attr("data-slot", "sheet-footer")]>
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
    <XoteBase.Dialog.Title
      ?id dataSlot="sheet-title" className={cn("cn-sheet-title cn-font-heading", className)}>
      {children}
    </XoteBase.Dialog.Title>
}

module Description = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Description
      ?id dataSlot="sheet-description" className={cn("cn-sheet-description", className)}>
      {children}
    </XoteBase.Dialog.Description>
}
