@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Orientation = XoteBase.Internal.Orientation

let buttonGroupVariants = (~orientation=Orientation.Horizontal) => {
  let base = "cn-button-group flex w-fit items-stretch *:focus-visible:relative *:focus-visible:z-10 [&>[data-slot=select-trigger]:not([class*='w-'])]:w-fit [&>input]:flex-1"
  let orientationClass = switch orientation {
  | Horizontal => "cn-button-group-orientation-horizontal *:data-slot:rounded-r-none [&>[data-slot]~[data-slot]]:rounded-l-none [&>[data-slot]~[data-slot]]:border-l-0"
  | Vertical => "cn-button-group-orientation-vertical flex-col *:data-slot:rounded-b-none [&>[data-slot]~[data-slot]]:rounded-t-none [&>[data-slot]~[data-slot]]:border-t-0"
  }
  `${base} ${orientationClass}`
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~orientation: Orientation.t=Horizontal,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    role="group"
    class={cn(buttonGroupVariants(~orientation), className)}
    attrs=[
      View.attr("data-slot", "button-group"),
      View.attr("data-orientation", orientation->Orientation.toString),
    ]>
    {children}
  </div>

module Text = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-button-group-text flex items-center [&_svg]:pointer-events-none", className)}
      attrs=[View.attr("data-slot", "button-group-text")]>
      {children}
    </div>
}

module Separator = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~orientation: Orientation.t=Vertical,
  ) =>
    <Separator
      ?id
      orientation
      dataSlot="button-group-separator"
      className={cn(
        "cn-button-group-separator relative self-stretch data-horizontal:mx-px data-horizontal:w-auto data-vertical:my-px data-vertical:h-auto",
        className,
      )}
    />
}
