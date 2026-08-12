/* Helpers for the `data` prop bag of Xote's JSX runtime, which takes an
   untyped object: `data={Attrs.data([("slot", "card")])}` renders
   `data-slot="card"`. */

let data = (entries: array<(string, string)>): Obj.t => Internal.Data.make(
  entries->Array.map(((name, value)) => (name, Internal.Data.str(value))),
)

let dataOpt = (entries: array<(string, option<string>)>): Obj.t => Internal.Data.make(
  entries->Array.filterMap(((name, value)) =>
    value->Option.map(value => (name, Internal.Data.str(value)))
  ),
)
