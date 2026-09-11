@xote.component
let make = () =>
  <Toggle ariaLabel="Toggle bookmark" size=Toggle.Size.Sm variant=Outline>
    <Icons.Bookmark className="group-aria-pressed/toggle:fill-foreground" />
    {"Bookmark"}
  </Toggle>
