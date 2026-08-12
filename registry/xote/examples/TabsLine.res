@xote.component
let make = () =>
  <Tabs defaultValue="overview">
    <Tabs.List variant=Line>
      <Tabs.Trigger value="overview"> {"Overview"} </Tabs.Trigger>
      <Tabs.Trigger value="analytics"> {"Analytics"} </Tabs.Trigger>
      <Tabs.Trigger value="reports"> {"Reports"} </Tabs.Trigger>
    </Tabs.List>
  </Tabs>
