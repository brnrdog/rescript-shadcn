module Orientation = Internal.Orientation

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~orientation: Orientation.t=Horizontal,
  ~decorative: bool=false,
  ~dataSlot: string="separator",
  ~style: option<string>=?,
) => {
  let name = orientation->Orientation.toString

  <div
    id=?{id}
    class=?{className}
    style=?{style}
    role={decorative ? "none" : "separator"}
    attrs=[
      View.optionalAttr("aria-orientation", decorative ? None : Some(name)),
      View.attr("data-slot", dataSlot),
      View.attr(`data-${name}`, ""),
    ]
  />
}
