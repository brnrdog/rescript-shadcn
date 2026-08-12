@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Direction = {
  @unboxed
  type t =
    | @as("top") Top
    | @as("right") Right
    | @as("bottom") Bottom
    | @as("left") Left
}

/* A drawer is a dialog pinned to an edge. Drag-to-dismiss is not implemented;
   it closes through its handle, its actions, Escape or the overlay. */
@xote.component
let make = (
  ~open_: option<MaybeSignal.t<bool>>=?,
  ~defaultOpen: bool=false,
  ~onOpenChange: option<bool => unit>=?,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Dialog.Root ?open_ defaultOpen ?onOpenChange modal=true>
    {children}
  </XoteBase.Dialog.Root>

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Trigger ?className ?id disabled dataSlot="drawer-trigger">
      {children}
    </XoteBase.Dialog.Trigger>
}

module Close = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Close ?className ?id dataSlot="drawer-close"> {children} </XoteBase.Dialog.Close>
}

module Overlay = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <XoteBase.Dialog.Backdrop
      ?id
      dataSlot="drawer-overlay"
      className={cn(
        "cn-drawer-overlay data-open:animate-in data-closed:animate-out data-closed:fade-out-0 data-open:fade-in-0 fixed inset-0 z-50",
        className,
      )}
    />
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~direction: Direction.t=Bottom,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Dialog.Portal>
      <Overlay />
      <XoteBase.Dialog.Popup
        ?id
        dataSlot="drawer-content"
        attrs=[View.attr("data-vaul-drawer-direction", (direction :> string))]
        className={cn(
          "cn-drawer-popup cn-drawer-content-base bg-background group/drawer-content fixed z-50 flex h-auto flex-col text-sm data-[vaul-drawer-direction=bottom]:inset-x-0 data-[vaul-drawer-direction=bottom]:bottom-0 data-[vaul-drawer-direction=bottom]:mt-24 data-[vaul-drawer-direction=bottom]:max-h-[80vh] data-[vaul-drawer-direction=bottom]:rounded-t-xl data-[vaul-drawer-direction=bottom]:border-t data-[vaul-drawer-direction=left]:inset-y-0 data-[vaul-drawer-direction=left]:left-0 data-[vaul-drawer-direction=left]:w-3/4 data-[vaul-drawer-direction=left]:rounded-r-xl data-[vaul-drawer-direction=left]:border-r data-[vaul-drawer-direction=right]:inset-y-0 data-[vaul-drawer-direction=right]:right-0 data-[vaul-drawer-direction=right]:w-3/4 data-[vaul-drawer-direction=right]:rounded-l-xl data-[vaul-drawer-direction=right]:border-l data-[vaul-drawer-direction=top]:inset-x-0 data-[vaul-drawer-direction=top]:top-0 data-[vaul-drawer-direction=top]:mb-24 data-[vaul-drawer-direction=top]:max-h-[80vh] data-[vaul-drawer-direction=top]:rounded-b-xl data-[vaul-drawer-direction=top]:border-b data-[vaul-drawer-direction=left]:sm:max-w-sm data-[vaul-drawer-direction=right]:sm:max-w-sm",
          className,
        )}>
        <div
          class="cn-drawer-swipe-handle cn-drawer-handle group-data-[vaul-drawer-direction=bottom]/drawer-content:block"
          attrs=[View.attr("data-slot", "drawer-handle"), View.attr("aria-hidden", "true")]
        />
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
      class={cn(
        "cn-drawer-header-base cn-drawer-header flex flex-col group-data-[vaul-drawer-direction=bottom]/drawer-content:text-center group-data-[vaul-drawer-direction=top]/drawer-content:text-center",
        className,
      )}
      attrs=[View.attr("data-slot", "drawer-header")]>
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
      class={cn("cn-drawer-footer-base cn-drawer-footer mt-auto flex flex-col", className)}
      attrs=[View.attr("data-slot", "drawer-footer")]>
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
      ?id dataSlot="drawer-title" className={cn("cn-drawer-title cn-font-heading", className)}>
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
      ?id dataSlot="drawer-description" className={cn("cn-drawer-description", className)}>
      {children}
    </XoteBase.Dialog.Description>
}
