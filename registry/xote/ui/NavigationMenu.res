@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Side = XoteBase.Anchored.Side
module Align = XoteBase.Anchored.Align

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <nav
    id=?{id}
    ariaLabel=?{ariaLabel}
    class={cn(
      "cn-navigation-menu group/navigation-menu relative flex flex-1 items-center justify-center",
      className,
    )}
    attrs=[View.attr("data-slot", "navigation-menu")]>
    {children}
  </nav>

module List = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <ul
      id=?{id}
      class={cn(
        "cn-navigation-menu-list group flex flex-1 list-none items-center justify-center",
        className,
      )}
      attrs=[View.attr("data-slot", "navigation-menu-list")]>
      {children}
    </ul>
}

/* Each item owns its own menu, so opening one leaves the others alone. */
module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <li
      id=?{id}
      class={cn("cn-navigation-menu-item relative", className)}
      attrs=[View.attr("data-slot", "navigation-menu-item")]>
      <XoteBase.Menu.Root modal=false> {children} </XoteBase.Menu.Root>
    </li>
}

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Trigger
      ?id
      disabled
      dataSlot="navigation-menu-trigger"
      className={cn("cn-navigation-menu-trigger group/navigation-menu-trigger", className)}>
      {children}
      <Icons.ChevronDown
        className="cn-navigation-menu-trigger-icon relative top-px ml-1 size-3 transition duration-300 group-aria-expanded/navigation-menu-trigger:rotate-180"
      />
    </XoteBase.Menu.Trigger>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~side: Side.t=Bottom,
    ~align: Align.t=Center,
    ~sideOffset: float=8.,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.Menu.Positioner
      side align sideOffset className="cn-navigation-menu-positioner isolate z-50">
      <XoteBase.Menu.Popup
        ?id
        dataSlot="navigation-menu-content"
        className={cn(
          "cn-navigation-menu-popup cn-navigation-menu-content bg-popover text-popover-foreground ring-foreground/10 origin-(--transform-origin) rounded-lg p-2 shadow ring-1 outline-none",
          className,
        )}>
        {children}
      </XoteBase.Menu.Popup>
    </XoteBase.Menu.Positioner>
}

module Link = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~href: option<string>=?,
    ~active: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <a
      id=?{id}
      href=?{href}
      class={cn("cn-navigation-menu-link block rounded-md p-2 outline-none", className)}
      attrs=[
        View.attr("data-slot", "navigation-menu-link"),
        View.optionalAttr("data-active", active ? Some("true") : None),
        View.optionalAttr("aria-current", active ? Some("page") : None),
      ]>
      {children}
    </a>
}
