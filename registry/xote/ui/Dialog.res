@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

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
    <XoteBase.Dialog.Trigger ?className ?id disabled ?ariaLabel dataSlot="dialog-trigger">
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
    <XoteBase.Dialog.Close ?className ?id ?ariaLabel dataSlot="dialog-close">
      {children}
    </XoteBase.Dialog.Close>
}

module Overlay = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <XoteBase.Dialog.Backdrop
      ?id
      dataSlot="dialog-overlay"
      className={cn("cn-dialog-overlay fixed inset-0 isolate z-50", className)}
    />
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~showCloseButton: bool=true,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Portal>
      <Overlay />
      <XoteBase.Dialog.Popup
        ?id
        dataSlot="dialog-content"
        className={cn(
          "cn-dialog-content bg-background data-open:animate-in data-closed:animate-out data-closed:fade-out-0 data-open:fade-in-0 data-closed:zoom-out-95 data-open:zoom-in-95 ring-foreground/10 fixed top-1/2 left-1/2 z-50 grid w-full max-w-[calc(100%-2rem)] -translate-x-1/2 -translate-y-1/2 gap-4 rounded-xl p-4 text-sm ring-1 duration-100 outline-none sm:max-w-sm",
          className,
        )}>
        {children}
        {showCloseButton
          ? <XoteBase.Dialog.Close
              dataSlot="dialog-close"
              className={Button.buttonVariants(
                ~variant=Ghost,
                ~size=IconSm,
                ~className="cn-dialog-close",
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
      class={cn("cn-dialog-header flex flex-col", className)}
      attrs=[View.attr("data-slot", "dialog-header")]>
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
      class={cn(
        "cn-dialog-header cn-dialog-footer flex flex-col-reverse sm:flex-row sm:justify-end",
        className,
      )}
      attrs=[View.attr("data-slot", "dialog-footer")]>
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
      ?id dataSlot="dialog-title" className={cn("cn-dialog-title cn-font-heading", className)}>
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
      ?id dataSlot="dialog-description" className={cn("cn-dialog-description", className)}>
      {children}
    </XoteBase.Dialog.Description>
}
