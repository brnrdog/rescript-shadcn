@xote.component
let make = () =>
  <Card className="w-full max-w-sm">
    <Card.Header>
      <Card.Title> {"Login to your account"} </Card.Title>
      <Card.Description> {"Enter your email below to login to your account"} </Card.Description>
      <Card.Action>
        <Button variant=Link> {"Sign Up"} </Button>
      </Card.Action>
    </Card.Header>
    <Card.Content>
      <div class="flex flex-col gap-6">
        <div class="grid gap-2">
          <Label for_="card-demo-email"> {"Email"} </Label>
          <Input id="card-demo-email" type_="email" placeholder="m@example.com" required=true />
        </div>
        <div class="grid gap-2">
          <Label for_="card-demo-password"> {"Password"} </Label>
          <Input id="card-demo-password" type_="password" required=true />
        </div>
      </div>
    </Card.Content>
    <Card.Footer className="flex-col gap-2">
      <Button type_="submit" className="w-full"> {"Login"} </Button>
      <Button variant=Outline className="w-full"> {"Login with Google"} </Button>
    </Card.Footer>
  </Card>
