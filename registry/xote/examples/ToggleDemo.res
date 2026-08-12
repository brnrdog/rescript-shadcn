@xote.component
let make = () =>
  <Toggle ariaLabel="Toggle bookmark" size=Sm variant=Outline>
    <Icons.Check className="group-aria-pressed/toggle:fill-foreground" />
    {"Bookmark"}
  </Toggle>
