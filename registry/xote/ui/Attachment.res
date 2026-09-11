@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module State = {
  @unboxed
  type t =
    | @as("idle") Idle
    | @as("uploading") Uploading
    | @as("processing") Processing
    | @as("error") Error
    | @as("ready") Ready
}

module Size = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("sm") Sm
    | @as("xs") Xs
}

module Orientation = {
  @unboxed
  type t =
    | @as("horizontal") Horizontal
    | @as("vertical") Vertical
}

module MediaVariant = {
  @unboxed
  type t =
    | @as("icon") Icon
    | @as("image") Image
}

let orientationClass = (~orientation: Orientation.t) =>
  switch orientation {
  | Horizontal => "cn-attachment-orientation-horizontal items-center"
  | Vertical => "cn-attachment-orientation-vertical flex-col"
  }

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~state: State.t=Ready,
  ~size: Size.t=Default,
  ~orientation: Orientation.t=Horizontal,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    class={cn(
      `cn-attachment group/attachment relative flex max-w-full min-w-0 shrink-0 flex-wrap border bg-card text-card-foreground transition-colors has-[>a,>button]:hover:bg-muted/50 data-[state=error]:border-destructive/30 data-[state=idle]:border-dashed cn-attachment-size-${(size :> string)} ${orientationClass(
          ~orientation,
        )}`,
      className,
    )}
    attrs=[
      View.attr("data-slot", "attachment"),
      View.attr("data-state", (state :> string)),
      View.attr("data-size", (size :> string)),
      View.attr("data-orientation", (orientation :> string)),
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
      class={cn(
        "cn-attachment-group flex min-w-0 scroll-fade-x snap-x snap-mandatory scrollbar-none overflow-x-auto overscroll-x-contain *:data-[slot=attachment]:flex-none *:data-[slot=attachment]:snap-start",
        className,
      )}
      attrs=[View.attr("data-slot", "attachment-group")]>
      {children}
    </div>
}

module Media = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~variant: MediaVariant.t=Icon,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        `cn-attachment-media relative flex aspect-square shrink-0 items-center justify-center overflow-hidden group-data-[state=error]/attachment:bg-destructive/10 group-data-[state=error]/attachment:text-destructive [&_svg]:pointer-events-none cn-attachment-media-variant-${(variant :> string)}${variant === Image
          ? " *:[img]:aspect-square *:[img]:w-full *:[img]:object-cover"
          : ""}`,
        className,
      )}
      attrs=[
        View.attr("data-slot", "attachment-media"),
        View.attr("data-variant", (variant :> string)),
      ]>
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
      class={cn("cn-attachment-content max-w-full min-w-0 flex-1", className)}
      attrs=[View.attr("data-slot", "attachment-content")]>
      {children}
    </div>
}

module Title = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <span
      id=?{id}
      class={cn(
        "cn-attachment-title block max-w-full min-w-0 truncate group-data-[state=processing]/attachment:shimmer group-data-[state=uploading]/attachment:shimmer",
        className,
      )}
      attrs=[View.attr("data-slot", "attachment-title")]>
      {children}
    </span>
}

module Description = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <span
      id=?{id}
      class={cn(
        "cn-attachment-description block max-w-full min-w-0 truncate text-muted-foreground group-data-[state=error]/attachment:text-destructive/80",
        className,
      )}
      attrs=[View.attr("data-slot", "attachment-description")]>
      {children}
    </span>
}

module Actions = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-attachment-actions flex shrink-0 items-center", className)}
      attrs=[View.attr("data-slot", "attachment-actions")]>
      {children}
    </div>
}

module Action = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~onClick: option<Dom.event => unit>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <Button
      ?id
      variant=Ghost
      size=IconXs
      ?ariaLabel
      ?onClick
      dataSlot="attachment-action"
      className={cn("cn-attachment-action relative z-20", className)}>
      {children}
    </Button>
}

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~href: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <a
      id=?{id}
      href=?{href}
      ariaLabel=?{ariaLabel}
      class={cn("cn-attachment-trigger absolute inset-0 z-10 outline-none", className)}
      attrs=[View.attr("data-slot", "attachment-trigger")]>
      {children}
    </a>
}
