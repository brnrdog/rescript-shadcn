@xote.component
let make = () =>
  <Tabs defaultValue="overview" className="w-[400px]">
    <Tabs.List>
      <Tabs.Trigger value="overview"> {"Overview"} </Tabs.Trigger>
      <Tabs.Trigger value="analytics"> {"Analytics"} </Tabs.Trigger>
      <Tabs.Trigger value="reports"> {"Reports"} </Tabs.Trigger>
    </Tabs.List>
    <Tabs.Content value="overview">
      <Card>
        <Card.Header>
          <Card.Title> {"Overview"} </Card.Title>
          <Card.Description>
            {"View your key metrics and recent project activity. Track progress across all your active projects."}
          </Card.Description>
        </Card.Header>
        <Card.Content className="text-muted-foreground text-sm">
          {"You have 12 active projects and 3 pending tasks."}
        </Card.Content>
      </Card>
    </Tabs.Content>
    <Tabs.Content value="analytics">
      <Card>
        <Card.Header>
          <Card.Title> {"Analytics"} </Card.Title>
          <Card.Description>
            {"Track performance and user engagement metrics. Monitor trends and identify growth opportunities."}
          </Card.Description>
        </Card.Header>
        <Card.Content className="text-muted-foreground text-sm">
          {"Page views are up 25% compared to last month."}
        </Card.Content>
      </Card>
    </Tabs.Content>
    <Tabs.Content value="reports">
      <Card>
        <Card.Header>
          <Card.Title> {"Reports"} </Card.Title>
          <Card.Description>
            {"Generate and download your detailed reports. Export data in multiple formats for analysis."}
          </Card.Description>
        </Card.Header>
        <Card.Content className="text-muted-foreground text-sm">
          {"You have 5 reports ready and available to export."}
        </Card.Content>
      </Card>
    </Tabs.Content>
  </Tabs>
