@xote.component
let make = () =>
  <div class="flex w-full max-w-sm flex-col gap-2">
    <Label for_="native-select-demo"> {"Framework"} </Label>
    <NativeSelect id="native-select-demo" name="framework">
      <NativeSelect.Option value="next"> {"Next.js"} </NativeSelect.Option>
      <NativeSelect.Option value="remix"> {"Remix"} </NativeSelect.Option>
      <NativeSelect.Option value="astro"> {"Astro"} </NativeSelect.Option>
    </NativeSelect>
  </div>
