type invoice = {invoice: string, status: string, method: string, amount: string}

let invoices = [
  {invoice: "INV001", status: "Paid", method: "Credit Card", amount: "$250.00"},
  {invoice: "INV002", status: "Pending", method: "PayPal", amount: "$150.00"},
  {invoice: "INV003", status: "Unpaid", method: "Bank Transfer", amount: "$350.00"},
]

@xote.component
let make = () =>
  <Table>
    <Table.Caption> {"A list of your recent invoices."} </Table.Caption>
    <Table.Header>
      <Table.Row>
        <Table.Head className="w-[100px]"> {"Invoice"} </Table.Head>
        <Table.Head> {"Status"} </Table.Head>
        <Table.Head> {"Method"} </Table.Head>
        <Table.Head className="text-right"> {"Amount"} </Table.Head>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      <View.For
        each={MaybeSignal.static(invoices)}
        by={invoice => invoice.invoice}
        render={invoice =>
          <Table.Row>
            <Table.Cell className="font-medium"> {invoice.invoice} </Table.Cell>
            <Table.Cell> {invoice.status} </Table.Cell>
            <Table.Cell> {invoice.method} </Table.Cell>
            <Table.Cell className="text-right"> {invoice.amount} </Table.Cell>
          </Table.Row>}
      />
    </Table.Body>
  </Table>
