@xote.component
let make = () =>
  <Alert className="max-w-md">
    <Icons.CheckCircle2 />
    <Alert.Title> {"Account updated successfully"} </Alert.Title>
    <Alert.Description>
      {"Your profile information has been saved. Changes will be reflected immediately."}
    </Alert.Description>
  </Alert>
