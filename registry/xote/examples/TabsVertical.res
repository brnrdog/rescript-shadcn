@xote.component
let make = () =>
  <Tabs defaultValue="account" orientation=Vertical>
    <Tabs.List>
      <Tabs.Trigger value="account"> {"Account"} </Tabs.Trigger>
      <Tabs.Trigger value="password"> {"Password"} </Tabs.Trigger>
      <Tabs.Trigger value="notifications"> {"Notifications"} </Tabs.Trigger>
    </Tabs.List>
  </Tabs>
