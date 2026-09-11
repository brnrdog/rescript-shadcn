@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Align = {
  @unboxed
  type t =
    | @as("start") Start
    | @as("end") End
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~align: Align.t=Start,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    class={cn(
      "cn-message group/message relative flex w-full min-w-0 data-[align=end]:flex-row-reverse",
      className,
    )}
    attrs=[
      View.attr("data-slot", "message"),
      View.attr("data-align", (align :> string)),
    ]>
    {children}
  </div>

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-message-group flex min-w-0 flex-col", className)}
      attrs=[View.attr("data-slot", "message-group")]>
      {children}
    </div>
}

module Avatar = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        "cn-message-avatar flex w-fit shrink-0 items-center justify-center self-end overflow-hidden rounded-full bg-muted",
        className,
      )}
      attrs=[View.attr("data-slot", "message-avatar")]>
      {children}
    </div>
}

module Content = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-message-content flex w-full min-w-0 flex-col wrap-break-word", className)}
      attrs=[View.attr("data-slot", "message-content")]>
      {children}
    </div>
}

module Header = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-message-header flex max-w-full min-w-0 items-center", className)}
      attrs=[View.attr("data-slot", "message-header")]>
      {children}
    </div>
}

module Footer = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        "cn-message-footer flex max-w-full min-w-0 items-center group-data-[align=end]/message:justify-end",
        className,
      )}
      attrs=[View.attr("data-slot", "message-footer")]>
      {children}
    </div>
}
