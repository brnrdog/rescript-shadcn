@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Orientation = XoteBase.Internal.Orientation

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~orientation: Orientation.t=Horizontal,
  ~decorative: bool=false,
  ~dataSlot: string="separator",
) =>
  <XoteBase.Separator
    ?id
    orientation
    decorative
    dataSlot
    className={cn(
      "cn-separator data-horizontal:h-px data-horizontal:w-full data-vertical:w-px data-vertical:self-stretch",
      className,
    )}
  />
