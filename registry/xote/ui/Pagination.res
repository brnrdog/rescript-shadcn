@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Size = {
  @unboxed
  type t =
    | @as("icon") Icon
    | @as("default") Default
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <nav
    id=?{id}
    role="navigation"
    ariaLabel="pagination"
    class={cn("cn-pagination mx-auto flex w-full justify-center", className)}
    attrs=[View.attr("data-slot", "pagination")]>
    {children}
  </nav>

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <ul
      id=?{id}
      class={cn("cn-pagination-content flex items-center", className)}
      attrs=[View.attr("data-slot", "pagination-content")]>
      {children}
    </ul>
}

module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <li id=?{id} class=?{className} attrs=[View.attr("data-slot", "pagination-item")]>
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
    ~isActive: bool=false,
    ~size: Size.t=Icon,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <a
      id=?{id}
      href=?{href}
      target=?{target}
      ariaLabel=?{ariaLabel}
      class={Button.buttonVariants(
        ~variant=isActive ? Outline : Ghost,
        ~size=size === Icon ? Icon : Default,
        ~className=cn("cn-pagination-link", className),
      )}
      attrs=[
        View.attr("data-slot", "pagination-link"),
        View.optionalAttr("aria-current", isActive ? Some("page") : None),
        View.optionalAttr("data-active", isActive ? Some("true") : None),
      ]>
      {children}
    </a>
}

module Previous = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~href: option<string>=?,
    ~text: string="Previous",
  ) =>
    <Link
      ?id
      ?href
      ariaLabel="Go to previous page"
      size=Default
      className={cn("cn-pagination-previous", className)}>
      <Icons.ChevronLeft dataIcon="inline-start" className="cn-rtl-flip" />
      <span class="cn-pagination-previous-text hidden sm:block"> {text} </span>
    </Link>
}

module Next = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~href: option<string>=?,
    ~text: string="Next",
  ) =>
    <Link
      ?id
      ?href
      ariaLabel="Go to next page"
      size=Default
      className={cn("cn-pagination-next", className)}>
      <span class="cn-pagination-next-text hidden sm:block"> {text} </span>
      <Icons.ChevronRight dataIcon="inline-end" className="cn-rtl-flip" />
    </Link>
}

module Ellipsis = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <span
      id=?{id}
      ariaHidden={true}
      class={cn("cn-pagination-ellipsis flex", className)}
      attrs=[View.attr("data-slot", "pagination-ellipsis")]>
      <Icons.MoreHorizontal />
      <span class="sr-only"> {"More pages"} </span>
    </span>
}
