@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~dataIcon: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <kbd
    id=?{id}
    class={cn(
      "cn-kbd pointer-events-none inline-flex items-center justify-center select-none",
      className,
    )}
    data={BaseXote.Attrs.dataOpt([("slot", Some("kbd")), ("icon", dataIcon)])}>
    {children}
  </kbd>

module Group = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <kbd
      id=?{id}
      class={cn("cn-kbd-group inline-flex items-center", className)}
      data={BaseXote.Attrs.data([("slot", "kbd-group")])}>
      {children}
    </kbd>
}
