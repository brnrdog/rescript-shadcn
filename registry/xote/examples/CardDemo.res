@xote.component
let make = () =>
  <Card className="w-full max-w-sm">
    <Card.Header>
      <Card.Title> {"Login to your account"} </Card.Title>
      <Card.Description>
        {"Enter your email below to login to your account"}
      </Card.Description>
      <Card.Action>
        <Button variant=Link> {"Sign Up"} </Button>
      </Card.Action>
    </Card.Header>
    <Card.Content>
      <form>
        <div class="flex flex-col gap-6">
          <div class="grid gap-2">
            <Label for_="email"> {"Email"} </Label>
            <Input id="email" type_="email" placeholder="m@example.com" required={true} />
          </div>
          <div class="grid gap-2">
            <div class="flex items-center">
              <Label for_="password"> {"Password"} </Label>
              <a
                href="#" class="ml-auto inline-block text-sm underline-offset-4 hover:underline"
              >
                {"Forgot your password?"}
              </a>
            </div>
            <Input id="password" type_="password" required={true} />
          </div>
        </div>
      </form>
    </Card.Content>
    <Card.Footer className="flex-col gap-2">
      <Button type_="submit" className="w-full"> {"Login"} </Button>
      <Button variant=Outline className="w-full"> {"Login with Google"} </Button>
    </Card.Footer>
  </Card>
