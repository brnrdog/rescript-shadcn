@xote.component
let make = () =>
  <Direction direction="rtl" className="w-full max-w-sm">
    <div class="flex flex-col gap-3">
      <Label for_="direction-demo"> {"البريد الإلكتروني"} </Label>
      <Input id="direction-demo" placeholder="m@example.com" />
      <Button variant=Outline> {"إرسال"} </Button>
    </div>
  </Direction>
