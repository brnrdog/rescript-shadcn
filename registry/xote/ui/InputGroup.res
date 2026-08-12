@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Align = {
  @unboxed
  type t =
    | @as("inline-start") InlineStart
    | @as("inline-end") InlineEnd
    | @as("block-start") BlockStart
    | @as("block-end") BlockEnd
}

module Size = {
  @unboxed
  type t =
    | @as("xs") Xs
    | @as("sm") Sm
    | @as("icon-xs") IconXs
    | @as("icon-sm") IconSm
}

let alignClass = (~align: Align.t) =>
  switch align {
  | InlineStart => "cn-input-group-addon-align-inline-start order-first"
  | InlineEnd => "cn-input-group-addon-align-inline-end order-last"
  | BlockStart => "cn-input-group-addon-align-block-start order-first w-full justify-start"
  | BlockEnd => "cn-input-group-addon-align-block-end order-last w-full justify-start"
  }

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    role="group"
    class={cn(
      "cn-input-group group/input-group relative flex w-full min-w-0 items-center outline-none has-[>textarea]:h-auto",
      className,
    )}
    attrs=[View.attr("data-slot", "input-group")]>
    {children}
  </div>

module Addon = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~align: Align.t=InlineStart,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        `cn-input-group-addon flex cursor-text items-center justify-center select-none ${alignClass(
            ~align,
          )}`,
        className,
      )}
      attrs=[
        View.attr("data-slot", "input-group-addon"),
        View.attr("data-align", (align :> string)),
      ]>
      {children}
    </div>
}

module Button = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~size: Size.t=Xs,
    ~variant: Button.Variant.t=Ghost,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~onClick: option<Dom.event => unit>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <Button
      ?id
      variant
      disabled
      ?ariaLabel
      ?onClick
      dataSlot="input-group-button"
      className={cn(
        `cn-input-group-button flex items-center shadow-none cn-input-group-button-size-${(size :> string)}`,
        className,
      )}>
      {children}
    </Button>
}

module Text = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <span
      id=?{id}
      class={cn("cn-input-group-text flex items-center [&_svg]:pointer-events-none", className)}
      attrs=[View.attr("data-slot", "input-group-text")]>
      {children}
    </span>
}

module Input = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~type_: string="text",
    ~name: option<string>=?,
    ~value: option<MaybeSignal.t<string>>=?,
    ~placeholder: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~onInput: option<Dom.event => unit>=?,
  ) =>
    <Input
      ?ariaLabel
      ?id
      type_
      ?name
      ?value
      ?placeholder
      disabled
      ?onInput
      className={cn("cn-input-group-input flex-1", className)}
    />
}

module Textarea = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~name: option<string>=?,
    ~value: option<MaybeSignal.t<string>>=?,
    ~placeholder: option<string>=?,
    ~disabled: bool=false,
    ~onInput: option<Dom.event => unit>=?,
  ) =>
    <Textarea
      ?id
      ?name
      ?value
      ?placeholder
      disabled
      ?onInput
      className={cn("cn-input-group-textarea flex-1 resize-none", className)}
    />
}
