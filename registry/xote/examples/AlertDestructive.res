@xote.component
let make = () =>
  <Alert variant=Alert.Variant.Destructive className="max-w-md">
    <Icons.AlertCircle />
    <Alert.Title> {"Payment failed"} </Alert.Title>
    <Alert.Description>
      {"Your payment could not be processed. Please check your payment method and try again."}
    </Alert.Description>
  </Alert>
