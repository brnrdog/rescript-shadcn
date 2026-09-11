@xote.component
let make = () =>
  <Alert className="max-w-md">
    <Alert.Title> {"Dark mode is now available"} </Alert.Title>
    <Alert.Description>
      {"Enable it under your profile settings to get started."}
    </Alert.Description>
    <Alert.Action>
      <Button size=Xs variant=Default> {"Enable"} </Button>
    </Alert.Action>
  </Alert>
