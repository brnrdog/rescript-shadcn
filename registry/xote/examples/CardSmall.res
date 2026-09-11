@xote.component
let make = () => {
  let featureName = "Scheduled reports"

  <Card size=Sm className="mx-auto w-full max-w-xs">
    <Card.Header>
      <Card.Title> {featureName} </Card.Title>
      <Card.Description>
        {"Weekly snapshots. No more manual exports."}
      </Card.Description>
    </Card.Header>
    <Card.Content>
      <ul class="grid gap-2 py-2 text-sm">
        <li class="flex gap-2">
          <Icons.ChevronRight className="text-muted-foreground mt-0.5 size-4 shrink-0" />
          <span> {"Choose a schedule (daily, or weekly)."} </span>
        </li>
        <li class="flex gap-2">
          <Icons.ChevronRight className="text-muted-foreground mt-0.5 size-4 shrink-0" />
          <span> {"Send to channels or specific teammates."} </span>
        </li>
        <li class="flex gap-2">
          <Icons.ChevronRight className="text-muted-foreground mt-0.5 size-4 shrink-0" />
          <span> {"Include charts, tables, and key metrics."} </span>
        </li>
      </ul>
    </Card.Content>
    <Card.Footer className="flex-col gap-2">
      <Button size=Sm className="w-full"> {"Set up scheduled reports"} </Button>
      <Button variant=Outline size=Sm className="w-full"> {"See what's new"} </Button>
    </Card.Footer>
  </Card>
}
