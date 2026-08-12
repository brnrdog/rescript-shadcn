@xote.component
let make = () =>
  <div class="grid w-full max-w-md items-start gap-4">
    <Alert>
      <Icons.Check />
      <Alert.Title> {"Payment successful"} </Alert.Title>
      <Alert.Description>
        {"Your payment of $29.99 has been processed. A receipt has been sent to your email address."}
      </Alert.Description>
    </Alert>
    <Alert variant=Destructive>
      <Icons.X />
      <Alert.Title> {"Payment failed"} </Alert.Title>
      <Alert.Description>
        {"We could not charge your card. Update your payment method and try again."}
      </Alert.Description>
    </Alert>
  </div>
