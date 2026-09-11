@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~dataIcon: option<string>=?,
  ~dataSlot: string="spinner",
) =>
  <Icons.Loader
    role="status"
    ariaLabel="Loading"
    dataSlot
    ?dataIcon
    className={cn("size-4 animate-spin", className)}
  />
