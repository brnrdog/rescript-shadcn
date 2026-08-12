@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
  <div
    id=?{id}
    class={cn("cn-skeleton animate-pulse", className)}
    attrs=[View.attr("data-slot", "skeleton")]>
    {children}
  </div>
