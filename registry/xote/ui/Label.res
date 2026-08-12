@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~for_: option<string>=?,
  ~dataSlot: string="label",
  ~children: View.node=View.fragment([]),
) =>
  <label
    id=?{id}
    for_=?{for_}
    class={cn(
      "cn-label flex items-center select-none group-data-[disabled=true]:pointer-events-none peer-disabled:cursor-not-allowed",
      className,
    )}
    attrs=[View.attr("data-slot", dataSlot)]>
    {children}
  </label>
