@xote.component
let make = () =>
  <div class="flex max-w-sm flex-col gap-4">
    <div class="flex items-center gap-3">
      <Checkbox id="terms-checkbox" name="terms-checkbox" />
      <Label for_="terms-checkbox"> {"Accept terms and conditions"} </Label>
    </div>
    <div class="flex items-center gap-3">
      <Checkbox id="terms-checkbox-2" name="terms-checkbox-2" defaultChecked=true />
      <Label for_="terms-checkbox-2"> {"Subscribe to the newsletter"} </Label>
    </div>
    <div class="flex items-center gap-3">
      <Checkbox id="toggle-checkbox" name="toggle-checkbox" disabled=true />
      <Label for_="toggle-checkbox"> {"Enable notifications"} </Label>
    </div>
  </div>
