module Orientation = Internal.Orientation

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~orientation: Orientation.t=Horizontal,
  ~decorative: bool=false,
  ~dataSlot: string="separator",
  ~style: option<string>=?,
) =>
  Internal.Node.make(
    ~tag="div",
    ~attrs=[
      ("id", id),
      ("class", className),
      ("style", style),
      ("role", decorative ? Some("none") : Some("separator")),
      ("aria-orientation", decorative ? None : Some(orientation->Orientation.toString)),
      ("data-slot", Some(dataSlot)),
      (`data-${orientation->Orientation.toString}`, Some("")),
    ],
  )
