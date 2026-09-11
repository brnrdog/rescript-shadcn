@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <div class="cn-table-container" attrs=[View.attr("data-slot", "table-container")]>
    <table
      id=?{id} class={cn("cn-table", className)} attrs=[View.attr("data-slot", "table")]>
      {children}
    </table>
  </div>

module Header = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <thead
      id=?{id}
      class={cn("cn-table-header", className)}
      attrs=[View.attr("data-slot", "table-header")]>
      {children}
    </thead>
}

module Body = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <tbody
      id=?{id}
      class={cn("cn-table-body", className)}
      attrs=[View.attr("data-slot", "table-body")]>
      {children}
    </tbody>
}

module Footer = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <tfoot
      id=?{id}
      class={cn("cn-table-footer", className)}
      attrs=[View.attr("data-slot", "table-footer")]>
      {children}
    </tfoot>
}

module Row = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataState: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <tr
      id=?{id}
      class={cn("cn-table-row", className)}
      attrs=[View.attr("data-slot", "table-row"), View.optionalAttr("data-state", dataState)]>
      {children}
    </tr>
}

module Head = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~colSpan: option<int>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <th
      id=?{id}
      class={cn("cn-table-head", className)}
      attrs=[
        View.attr("data-slot", "table-head"),
        View.optionalAttr("colspan", colSpan->Option.map(value => value->Int.toString)),
      ]>
      {children}
    </th>
}

module Cell = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~colSpan: option<int>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <td
      id=?{id}
      class={cn("cn-table-cell", className)}
      attrs=[
        View.attr("data-slot", "table-cell"),
        View.optionalAttr("colspan", colSpan->Option.map(value => value->Int.toString)),
      ]>
      {children}
    </td>
}

module Caption = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <caption
      id=?{id}
      class={cn("cn-table-caption", className)}
      attrs=[View.attr("data-slot", "table-caption")]>
      {children}
    </caption>
}
