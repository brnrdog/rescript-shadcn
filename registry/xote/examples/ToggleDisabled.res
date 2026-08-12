@xote.component
let make = () =>
  <div class="flex flex-wrap items-center gap-2">
    <Toggle ariaLabel="Toggle disabled" disabled={true}> {"Disabled"} </Toggle>
    <Toggle variant=Outline ariaLabel="Toggle disabled outline" disabled={true}>
      {"Disabled"}
    </Toggle>
  </div>
