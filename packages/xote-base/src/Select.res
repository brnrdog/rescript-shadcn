/* A listbox select built on the menu machinery: same anchored portal and roving
   focus, with listbox roles and a selected value the trigger can render. */

module Ctx = {
  type t = {
    selected: unit => string,
    select: string => unit,
    labels: Dict.t<string>,
    placeholder: string,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()

let use = () => Internal.Context.use(context)

module Value = {
  @xote.component
  let make = (~className: option<string>=?, ~dataSlot: string="select-value") => {
    let ctx = use()

    <span
      class=?{className}
      attrs=[
        View.attr("data-slot", dataSlot),
        View.optionalComputedAttr("data-placeholder", () =>
          switch ctx {
          | Some(ctx) => ctx.selected() === "" ? Some("") : None
          | None => Some("")
          }
        ),
      ]>
      {View.signalText(() =>
        switch ctx {
        | Some(ctx) =>
          let value = ctx.selected()
          value === "" ? ctx.placeholder : ctx.labels->Dict.get(value)->Option.getOr(value)
        | None => ""
        }
      )}
    </span>
  }
}

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="select-trigger",
    ~dataSize: option<string>=?,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) =>
    <Menu.Trigger
      ?id
      disabled
      ?ariaLabel
      dataSlot
      ?style
      ?className
      attrs=[View.attr("role", "combobox"), View.attr("aria-haspopup", "listbox")]
      dataSize=?{dataSize}>
      {children}
    </Menu.Trigger>
}

module Item = {
  @xote.component
  let make = (
    ~value: string,
    ~label: option<string>=?,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~dataSlot: string="select-item",
    ~indicatorClassName: option<string>=?,
    ~indicator: View.node=Internal.noChildren,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let isSelected = () => ctx->Option.mapOr(false, ctx => ctx.selected() === value)

    /* The trigger renders the selected item's text, so each item registers its
       label as it mounts. */
    switch (ctx, label) {
    | (Some(ctx), Some(label)) => ctx.labels->Dict.set(value, label)
    | _ => ()
    }

    <Menu.Item
      ?id
      disabled
      role="option"
      dataSlot
      ?style
      ?className
      onSelect={() =>
        switch ctx {
        | Some({select}) => select(value)
        | None => ()
        }}
      attrs=[
        Internal.boolAttr("aria-selected", isSelected),
        Internal.flag("data-selected", isSelected),
        Internal.flag("data-checked", isSelected),
      ]>
      <span
        class=?{indicatorClassName}
        attrs=[
          View.attr("data-slot", `${dataSlot}-indicator`),
          View.optionalComputedAttr("hidden", () => isSelected() ? None : Some("true")),
        ]>
        {indicator}
      </span>
      {children}
    </Menu.Item>
  }
}

module Popup = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="select-popup",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) =>
    <Menu.Popup ?id ?className ?style dataSlot attrs=[View.attr("role", "listbox")]>
      {children}
    </Menu.Popup>
}

module Positioner = Menu.Positioner

module Root = {
  @xote.component
  let make = (
    ~id: option<string>=?,
    ~value: option<MaybeSignal.t<string>>=?,
    ~defaultValue: string="",
    ~onValueChange: option<string => unit>=?,
    ~open_: option<MaybeSignal.t<bool>>=?,
    ~defaultOpen: bool=false,
    ~onOpenChange: option<bool => unit>=?,
    ~placeholder: string="",
    ~children: View.node=Internal.noChildren,
  ) => {
    let state = Internal.Controlled.make(~value, ~defaultValue, ~onChange=onValueChange)

    let ctx: Ctx.t = {
      selected: state.get,
      select: state.set,
      labels: Dict.make(),
      placeholder,
    }

    <Menu.Root ?id ?open_ defaultOpen ?onOpenChange modal=false>
      {Internal.Context.provide(context, ctx, children)}
    </Menu.Root>
  }
}
