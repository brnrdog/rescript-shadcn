/* Inline icons, so the components stay free of a React icon dependency.
   Paths mirror the lucide icons used by the React registries. */

module Svg = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~role: option<string>=?,
    ~children: View.node,
  ) =>
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      class=?{className}
      role=?{role}
      ariaLabel=?{ariaLabel}
      attrs=[View.optionalAttr("data-slot", dataSlot), View.optionalAttr("data-icon", dataIcon)]>
      {children}
    </svg>
}

module Check = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="M20 6 9 17l-5-5" />
    </Svg>
}

module ChevronDown = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="m6 9 6 6 6-6" />
    </Svg>
}

module ChevronUp = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="m18 15-6-6-6 6" />
    </Svg>
}

module ChevronRight = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="m9 18 6-6-6-6" />
    </Svg>
}

module X = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="M18 6 6 18" />
      <path d="m6 6 12 12" />
    </Svg>
}

module ArrowUp = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="m5 12 7-7 7 7" />
      <path d="M12 19V5" />
    </Svg>
}

module Minus = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="M5 12h14" />
    </Svg>
}

module Loader = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~role: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon ?ariaLabel ?role>
      <path d="M21 12a9 9 0 1 1-6.219-8.56" />
    </Svg>
}

module MoreHorizontal = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <circle cx="12" cy="12" r="1" />
      <circle cx="19" cy="12" r="1" />
      <circle cx="5" cy="12" r="1" />
    </Svg>
}

module ChevronLeft = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="m15 18-6-6 6-6" />
    </Svg>
}

module Plus = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <path d="M5 12h14" />
      <path d="M12 5v14" />
    </Svg>
}

module Search = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~dataSlot: option<string>=?,
    ~dataIcon: option<string>=?,
  ) =>
    <Svg ?className ?dataSlot ?dataIcon>
      <circle cx="11" cy="11" r="8" />
      <path d="m21 21-4.3-4.3" />
    </Svg>
}
