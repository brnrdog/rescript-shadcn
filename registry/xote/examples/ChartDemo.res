let data: array<Chart.point> = [
  {label: "January", value: 186.},
  {label: "February", value: 305.},
  {label: "March", value: 237.},
  {label: "April", value: 273.},
  {label: "May", value: 209.},
  {label: "June", value: 314.},
]

@xote.component
let make = () =>
  <Card className="w-full max-w-md">
    <Card.Header>
      <Card.Title> {"Visitors"} </Card.Title>
      <Card.Description> {"January – June 2024"} </Card.Description>
    </Card.Header>
    <Card.Content>
      <Chart.Bar data ariaLabel="Visitors per month" />
    </Card.Content>
  </Card>
