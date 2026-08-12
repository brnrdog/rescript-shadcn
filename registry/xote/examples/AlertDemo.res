@xote.component
let make = () =>
  <div class="grid w-full max-w-md items-start gap-4">
    <Alert>
      <Icons.CheckCircle2 />
      <Alert.Title> {"Payment successful"} </Alert.Title>
      <Alert.Description>
        {"Your payment of $29.99 has been processed. A receipt has been sent to your email address."}
      </Alert.Description>
    </Alert>
    <Alert>
      <Icons.Info />
      <Alert.Title> {"New feature available"} </Alert.Title>
      <Alert.Description>
        {"We've added dark mode support. You can enable it in your account settings."}
      </Alert.Description>
    </Alert>
  </div>
