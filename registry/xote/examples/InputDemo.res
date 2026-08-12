@xote.component
let make = () =>
  <div class="flex w-full max-w-sm flex-col gap-2">
    <Label for_="input-demo-api-key"> {"API Key"} </Label>
    <Input id="input-demo-api-key" type_="password" placeholder="sk-..." />
    <p class="text-muted-foreground text-sm">
      {"Your API key is encrypted and stored securely."}
    </p>
  </div>
