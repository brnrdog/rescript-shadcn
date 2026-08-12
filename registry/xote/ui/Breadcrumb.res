@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <nav
    id=?{id}
    ariaLabel="breadcrumb"
    class={cn("cn-breadcrumb", className)}
    attrs=[View.attr("data-slot", "breadcrumb")]>
    {children}
  </nav>

module List = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <ol
      id=?{id}
      class={cn("cn-breadcrumb-list flex flex-wrap items-center wrap-break-word", className)}
      attrs=[View.attr("data-slot", "breadcrumb-list")]>
      {children}
    </ol>
}

module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <li
      id=?{id}
      class={cn("cn-breadcrumb-item inline-flex items-center", className)}
      attrs=[View.attr("data-slot", "breadcrumb-item")]>
      {children}
    </li>
}

module Link = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~href: option<string>=?,
    ~target: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <a
      id=?{id}
      href=?{href}
      target=?{target}
      class={cn("cn-breadcrumb-link", className)}
      attrs=[View.attr("data-slot", "breadcrumb-link")]>
      {children}
    </a>
}

module Page = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <span
      id=?{id}
      role="link"
      class={cn("cn-breadcrumb-page", className)}
      attrs=[
        View.attr("aria-current", "page"),
        View.attr("aria-disabled", "true"),
        View.attr("data-slot", "breadcrumb-page"),
      ]>
      {children}
    </span>
}

module Separator = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <li
      id=?{id}
      role="presentation"
      ariaHidden={true}
      class={cn("cn-breadcrumb-separator", className)}
      attrs=[View.attr("data-slot", "breadcrumb-separator")]>
      {children}
    </li>
}

module Ellipsis = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <span
      id=?{id}
      role="presentation"
      ariaHidden={true}
      class={cn("cn-breadcrumb-ellipsis flex items-center justify-center", className)}
      attrs=[View.attr("data-slot", "breadcrumb-ellipsis")]>
      <Icons.MoreHorizontal />
      <span class="sr-only"> {"More"} </span>
    </span>
}
