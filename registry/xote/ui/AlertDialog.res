@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Size = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("sm") Sm
}

/* An alert dialog interrupts: it is dismissed through its own actions, not by
   clicking away. */
@xote.component
let make = (
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Dialog.Root ?open_ defaultOpen ?onOpenChange modal=true dismissible=false>
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
    <XoteBase.Dialog.Trigger ?className ?id disabled ?ariaLabel dataSlot="alert-dialog-trigger">
      {children}
    </XoteBase.Dialog.Trigger>
}

module Overlay = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <XoteBase.Dialog.Backdrop
      ?id
      dataSlot="alert-dialog-overlay"
      className={cn("cn-alert-dialog-overlay fixed inset-0 isolate z-50", className)}
    />
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~size: Size.t=Default,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Portal>
      <Overlay />
      <XoteBase.Dialog.Popup
        ?id
        dataSlot="alert-dialog-content"
        dataSize={(size :> string)}
        attrs=[View.attr("role", "alertdialog")]
        className={cn(
          "cn-alert-dialog-content data-open:animate-in data-closed:animate-out data-closed:fade-out-0 data-open:fade-in-0 data-closed:zoom-out-95 data-open:zoom-in-95 bg-background ring-foreground/10 group/alert-dialog-content fixed top-1/2 left-1/2 z-50 grid w-full -translate-x-1/2 -translate-y-1/2 gap-4 rounded-xl p-4 ring-1 duration-100 outline-none data-[size=default]:max-w-xs data-[size=sm]:max-w-xs data-[size=default]:sm:max-w-sm",
          className,
        )}>
        {children}
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
      class={cn("cn-alert-dialog-header", className)}
      attrs=[View.attr("data-slot", "alert-dialog-header")]>
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
        "cn-alert-dialog-footer flex flex-col-reverse gap-2 group-data-[size=sm]/alert-dialog-content:grid group-data-[size=sm]/alert-dialog-content:grid-cols-2 sm:flex-row sm:justify-end",
        className,
      )}
      attrs=[View.attr("data-slot", "alert-dialog-footer")]>
      {children}
    </div>
}

module Media = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-alert-dialog-media", className)}
      attrs=[View.attr("data-slot", "alert-dialog-media")]>
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
      ?id
      dataSlot="alert-dialog-title"
      className={cn("cn-alert-dialog-title cn-font-heading", className)}>
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
      ?id dataSlot="alert-dialog-description" className={cn("cn-alert-dialog-description", className)}>
      {children}
    </XoteBase.Dialog.Description>
}

module Action = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~variant: Button.Variant.t=Default,
    ~size: Button.Size.t=Default,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Close
      ?id
      dataSlot="alert-dialog-action"
      className={Button.buttonVariants(
        ~variant,
        ~size,
        ~className=cn("cn-alert-dialog-action", className),
      )}>
      {children}
    </XoteBase.Dialog.Close>
}

module Cancel = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~variant: Button.Variant.t=Outline,
    ~size: Button.Size.t=Default,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Close
      ?id
      dataSlot="alert-dialog-cancel"
      className={Button.buttonVariants(
        ~variant,
        ~size,
        ~className=cn("cn-alert-dialog-cancel", className),
      )}>
      {children}
    </XoteBase.Dialog.Close>
}
