type payment = {id: string, status: string, email: string, amount: string}

let payments = [
  {id: "m5gr84i9", status: "success", email: "ken99@example.com", amount: "$316.00"},
  {id: "3u1reuv4", status: "success", email: "abe45@example.com", amount: "$242.00"},
  {id: "derv1ws0", status: "processing", email: "monserrat44@example.com", amount: "$837.00"},
  {id: "bhqecj4p", status: "failed", email: "carmella@example.com", amount: "$721.00"},
]

let columns: array<DataTable.column<payment>> = [
  DataTable.column(~key="status", ~header="Status", ~value=payment => payment.status),
  DataTable.column(~key="email", ~header="Email", ~value=payment => payment.email),
  DataTable.column(~key="amount", ~header="Amount", ~value=payment => payment.amount),
]

let inputValue: Dom.event => string = %raw(`function (event) { return event.target.value || "" }`)

@xote.component
let make = () => {
  let filter = Signal.make("")

  <div class="flex w-full flex-col gap-4">
    <Input
      placeholder="Filter emails..."
      value={MaybeSignal.reactive(filter)}
      onInput={event => Signal.set(filter, inputValue(event))}
      className="max-w-sm"
    />
    <DataTable
      rows=payments
      columns
      rowKey={payment => payment.id}
      filter={MaybeSignal.reactive(filter)}
    />
  </div>
}
