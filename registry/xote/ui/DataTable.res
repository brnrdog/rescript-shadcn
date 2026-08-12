@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* Sorting and filtering over an array of rows, driven by signals. The React
   registries lean on @tanstack/react-table; the state here is small enough to
   own directly. */
type column<'row> = {
  key: string,
  header: string,
  value: 'row => string,
  sortable: bool,
}

let column = (~key, ~header, ~value, ~sortable=true) => {key, header, value, sortable}

module Direction = {
  type t = Ascending | Descending
}

let sortRows = (rows, column: column<'row>, direction) =>
  rows
  ->Array.toSorted((a, b) => {
    let left = column.value(a)
    let right = column.value(b)
    let order = left < right ? -1. : left > right ? 1. : 0.
    direction === Direction.Ascending ? order : -.order
  })

@xote.component
let make = (
  ~rows: array<'row>,
  ~columns: array<column<'row>>,
  ~rowKey: 'row => string,
  ~filter: option<MaybeSignal.t<string>>=?,
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~emptyMessage: string="No results.",
) => {
  let sortKey = Signal.make(None)
  let direction = Signal.make(Direction.Ascending)

  let toggleSort = (column: column<'row>) =>
    if column.sortable {
      switch Signal.peek(sortKey) {
      | Some(key) if key === column.key =>
        Signal.set(
          direction,
          Signal.peek(direction) === Direction.Ascending
            ? Direction.Descending
            : Direction.Ascending,
        )
      | _ =>
        Signal.set(sortKey, Some(column.key))
        Signal.set(direction, Direction.Ascending)
      }
    }

  let visibleRows = () => {
    let needle =
      switch filter {
      | Some(filter) => MaybeSignal.get(filter)->String.trim->String.toLowerCase
      | None => ""
      }

    let filtered = needle === ""
      ? rows
      : rows->Array.filter(row =>
          columns->Array.some(column => column.value(row)->String.toLowerCase->String.includes(needle))
        )

    switch Signal.get(sortKey) {
    | Some(key) =>
      switch columns->Array.find(column => column.key === key) {
      | Some(column) => sortRows(filtered, column, Signal.get(direction))
      | None => filtered
      }
    | None => filtered
    }
  }

  <div
    id=?{id}
    class={cn("cn-data-table w-full", className)}
    attrs=[View.attr("data-slot", "data-table")]>
    <Table>
      <Table.Header>
        <Table.Row>
          <View.For
            each={MaybeSignal.static(columns)}
            by={column => column.key}
            render={column =>
              <Table.Head>
                {column.sortable
                  ? <button
                      type_="button"
                      class="inline-flex items-center gap-1 outline-none"
                      onClick={_ => toggleSort(column)}
                      attrs=[
                        View.computedAttr("aria-sort", () =>
                          switch Signal.get(sortKey) {
                          | Some(key) if key === column.key =>
                            Signal.get(direction) === Direction.Ascending
                              ? "ascending"
                              : "descending"
                          | _ => "none"
                          }
                        ),
                      ]>
                      {column.header}
                      <Icons.ChevronDown className="size-3 opacity-60" />
                    </button>
                  : View.text(column.header)}
              </Table.Head>}
          />
        </Table.Row>
      </Table.Header>
      <Table.Body>
        <View.For
          each={MaybeSignal.computed(visibleRows)}
          by={row => rowKey(row)}
          render={row =>
            <Table.Row>
              <View.For
                each={MaybeSignal.static(columns)}
                by={column => column.key}
                render={column => <Table.Cell> {column.value(row)} </Table.Cell>}
              />
            </Table.Row>}
        />
      </Table.Body>
    </Table>
    <div
      class="text-muted-foreground p-4 text-center text-sm"
      attrs=[
        View.attr("data-slot", "data-table-empty"),
        View.optionalComputedAttr("hidden", () =>
          visibleRows()->Array.length === 0 ? None : Some("true")
        ),
      ]>
      {emptyMessage}
    </div>
  </div>
}
