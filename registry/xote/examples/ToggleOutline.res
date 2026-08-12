@xote.component
let make = () =>
  <div class="flex flex-wrap items-center gap-2">
    <Toggle variant=Outline ariaLabel="Toggle italic">
      <Icons.Italic />
      {"Italic"}
    </Toggle>
    <Toggle variant=Outline ariaLabel="Toggle bold">
      <Icons.Bold />
      {"Bold"}
    </Toggle>
  </div>
