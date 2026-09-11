@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~ratio: string,
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    style={`--ratio: ${ratio}`}
    class={cn("relative aspect-(--ratio)", className)}
    attrs=[View.attr("data-slot", "aspect-ratio")]>
    {children}
  </div>
