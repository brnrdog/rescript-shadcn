@xote.component
let make = () =>
  <InputOtp length=6 ariaLabel="One-time password">
    <InputOtp.Group>
      <InputOtp.Slot index=0 />
      <InputOtp.Slot index=1 />
      <InputOtp.Slot index=2 />
    </InputOtp.Group>
    <InputOtp.Separator />
    <InputOtp.Group>
      <InputOtp.Slot index=3 />
      <InputOtp.Slot index=4 />
      <InputOtp.Slot index=5 />
    </InputOtp.Group>
  </InputOtp>
