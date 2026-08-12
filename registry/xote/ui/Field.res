@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Orientation = {
  @unboxed
  type t =
    | @as("vertical") Vertical
    | @as("horizontal") Horizontal
    | @as("responsive") Responsive
}

let orientationClass = (~orientation: Orientation.t) =>
  switch orientation {
  | Horizontal => "cn-field-orientation-horizontal flex-row items-center *:data-[slot=field-label]:flex-auto has-[>[data-slot=field-content]]:items-start has-[>[data-slot=field-content]]:[&>[role=checkbox],[role=radio]]:mt-px"
  | Responsive => "cn-field-orientation-responsive flex-col *:w-full [&>.sr-only]:w-auto @md/field-group:flex-row @md/field-group:items-center @md/field-group:*:w-auto @md/field-group:*:data-[slot=field-label]:flex-auto @md/field-group:has-[>[data-slot=field-content]]:items-start @md/field-group:has-[>[data-slot=field-content]]:[&>[role=checkbox],[role=radio]]:mt-px"
  | Vertical => "cn-field-orientation-vertical flex-col *:w-full [&>.sr-only]:w-auto"
  }

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~orientation: Orientation.t=Vertical,
  ~invalid: bool=false,
  ~dataInvalid: bool=false,
  ~disabled: bool=false,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    role="group"
    class={cn(`cn-field group/field flex w-full ${orientationClass(~orientation)}`, className)}
    attrs=[
      View.attr("data-slot", "field"),
      View.attr("data-orientation", (orientation :> string)),
      View.optionalAttr("data-invalid", invalid || dataInvalid ? Some("true") : None),
      View.optionalAttr("data-disabled", disabled ? Some("true") : None),
    ]>
    {children}
  </div>

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="field-group",
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        "cn-field-group group/field-group @container/field-group flex w-full flex-col",
        className,
      )}
      attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </div>
}

module Set = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <fieldset
      id=?{id}
      class={cn("cn-field-set flex flex-col", className)}
      attrs=[View.attr("data-slot", "field-set")]>
      {children}
    </fieldset>
}

module Legend = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~variant: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <legend
      id=?{id}
      class={cn("cn-field-legend", className)}
      attrs=[
        View.attr("data-slot", "field-legend"),
        View.optionalAttr("data-variant", variant),
      ]>
      {children}
    </legend>
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
      class={cn("cn-field-content group/field-content flex flex-1 flex-col leading-snug", className)}
      attrs=[View.attr("data-slot", "field-content")]>
      {children}
    </div>
}

module Label = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~for_: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <label
      id=?{id}
      for_=?{for_}
      class={cn(
        "cn-field-label group/field-label peer/field-label flex w-fit has-[>[data-slot=field]]:w-full has-[>[data-slot=field]]:flex-col",
        className,
      )}
      attrs=[View.attr("data-slot", "field-label")]>
      {children}
    </label>
}

module Title = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-field-title flex w-fit items-center", className)}
      attrs=[View.attr("data-slot", "field-title")]>
      {children}
    </div>
}

module Description = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <p
      id=?{id}
      class={cn(
        "cn-field-description leading-normal font-normal group-has-data-horizontal/field:text-balance last:mt-0 nth-last-2:-mt-1 [&>a:hover]:text-primary [&>a]:underline [&>a]:underline-offset-4",
        className,
      )}
      attrs=[View.attr("data-slot", "field-description")]>
      {children}
    </p>
}

module Error = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      role="alert"
      class={cn("cn-field-error font-normal", className)}
      attrs=[View.attr("data-slot", "field-error")]>
      {children}
    </div>
}

module Separator = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-field-separator relative", className)}
      attrs=[View.attr("data-slot", "field-separator")]>
      <Separator />
      {XoteBase.Internal.hasChildren(children)
        ? <span
            class="cn-field-separator-content bg-background relative mx-auto block w-fit"
            attrs=[View.attr("data-slot", "field-separator-content")]>
            {children}
          </span>
        : View.fragment([])}
    </div>
}
