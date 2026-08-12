@xote.component
let make = () =>
  <Tabs defaultValue="home">
    <Tabs.List>
      <Tabs.Trigger value="home"> {"Home"} </Tabs.Trigger>
      <Tabs.Trigger value="settings" disabled={true}> {"Disabled"} </Tabs.Trigger>
    </Tabs.List>
  </Tabs>
