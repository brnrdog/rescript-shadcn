@xote.component
let make = () =>
  <div class="flex flex-wrap items-center gap-2">
    <Toggle variant=Outline ariaLabel="Toggle small" size=Toggle.Size.Sm>
      {"Small"}
    </Toggle>
    <Toggle variant=Outline ariaLabel="Toggle default" size=Toggle.Size.Default>
      {"Default"}
    </Toggle>
    <Toggle variant=Outline ariaLabel="Toggle large" size=Toggle.Size.Lg>
      {"Large"}
    </Toggle>
  </div>
