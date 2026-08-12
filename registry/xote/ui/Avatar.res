@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Size = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("sm") Sm
    | @as("lg") Lg
}

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~size: Size.t=Default,
  ~children: View.node=View.fragment([]),
) =>
  <BaseXote.Avatar.Root
    ?id
    dataSlot="avatar"
    dataSize={(size :> string)}
    className={cn(
      "cn-avatar after:border-border group/avatar relative flex shrink-0 select-none after:absolute after:inset-0 after:border after:mix-blend-darken dark:after:mix-blend-lighten",
      className,
    )}>
    {children}
  </BaseXote.Avatar.Root>

module Image = {
  @xote.component
  let make = (
    ~src: string,
    ~alt: string="",
    ~className: option<string>=?,
    ~id: option<string>=?,
  ) =>
    <BaseXote.Avatar.Image
      src
      alt
      ?id
      dataSlot="avatar-image"
      className={cn("cn-avatar-image aspect-square size-full object-cover", className)}
    />
}

module Fallback = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <BaseXote.Avatar.Fallback
      ?id
      dataSlot="avatar-fallback"
      className={cn(
        "cn-avatar-fallback flex size-full items-center justify-center text-sm group-data-[size=sm]/avatar:text-xs",
        className,
      )}>
      {children}
    </BaseXote.Avatar.Fallback>
}

module Group = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn(
        "cn-avatar-group *:data-[slot=avatar]:ring-background group/avatar-group flex -space-x-2 *:data-[slot=avatar]:ring-2",
        className,
      )}
      data={BaseXote.Attrs.data([("slot", "avatar-group")])}>
      {children}
    </div>
}

module GroupCount = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <div
      id=?{id}
      class={cn(
        "cn-avatar-group-count ring-background relative flex shrink-0 items-center justify-center ring-2",
        className,
      )}
      data={BaseXote.Attrs.data([("slot", "avatar-group-count")])}>
      {children}
    </div>
}

module Badge = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <span
      id=?{id}
      class={cn(
        "cn-avatar-image cn-avatar-badge absolute right-0 bottom-0 z-10 inline-flex items-center justify-center bg-blend-color ring-2 select-none group-data-[size=sm]/avatar:size-2 group-data-[size=sm]/avatar:[&>svg]:hidden group-data-[size=default]/avatar:size-2.5 group-data-[size=default]/avatar:[&>svg]:size-2 group-data-[size=lg]/avatar:size-3 group-data-[size=lg]/avatar:[&>svg]:size-2",
        className,
      )}
      data={BaseXote.Attrs.data([("slot", "avatar-badge")])}>
      {children}
    </span>
}
