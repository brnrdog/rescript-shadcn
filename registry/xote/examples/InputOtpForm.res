@xote.component
let make = () =>
  <Card className="mx-auto max-w-md">
    <Card.Header>
      <Card.Title> {"Verify your login"} </Card.Title>
      <Card.Description>
        {"Enter the verification code we sent to your email address: "}
        <span class="font-medium"> {"m@example.com"} </span>
        {"."}
      </Card.Description>
    </Card.Header>
    <Card.Content>
      <Field>
        <div class="flex items-center justify-between">
          <Field.Label for_="otp-verification">
            {"Verification code"}
          </Field.Label>
          <Button variant=Outline size=Xs>
            <Icons.RefreshCw />
            {"Resend Code"}
          </Button>
        </div>
        <InputOtp maxLength={6} id="otp-verification" required={true}>
          <InputOtp.Group
            className="*:data-[slot=input-otp-slot]:h-12 *:data-[slot=input-otp-slot]:w-11 *:data-[slot=input-otp-slot]:text-xl"
          >
            <InputOtp.Slot index={0} />
            <InputOtp.Slot index={1} />
            <InputOtp.Slot index={2} />
          </InputOtp.Group>
          <InputOtp.Separator className="mx-2" />
          <InputOtp.Group
            className="*:data-[slot=input-otp-slot]:h-12 *:data-[slot=input-otp-slot]:w-11 *:data-[slot=input-otp-slot]:text-xl"
          >
            <InputOtp.Slot index={3} />
            <InputOtp.Slot index={4} />
            <InputOtp.Slot index={5} />
          </InputOtp.Group>
        </InputOtp>
        <Field.Description>
          <a href="#"> {"I no longer have access to this email address."} </a>
        </Field.Description>
      </Field>
    </Card.Content>
    <Card.Footer>
      <Field>
        <Button type_="submit" className="w-full"> {"Verify"} </Button>
        <div class="text-muted-foreground text-sm">
          {"Having trouble signing in? "}
          <a href="#" class="hover:text-primary underline underline-offset-4 transition-colors">
            {"Contact support"}
          </a>
        </div>
      </Field>
    </Card.Footer>
  </Card>
