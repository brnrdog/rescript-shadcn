/* Menus: dropdown, context menu and menubar all use this. An open menu owns
   keyboard navigation across its items, closes on Escape or a press outside,
   and returns focus to its trigger. */

module Ctx = {
  type t = {
    isOpen: unit => bool,
    setOpen: bool => unit,
    triggerId: string,
    popupId: string,
    modal: bool,
  }
}

module RadioCtx = {
  type t = {
    selected: unit => string,
    select: string => unit,
  }
}

let context: Internal.Context.t<Ctx.t> = Internal.Context.make()
let radioContext: Internal.Context.t<RadioCtx.t> = Internal.Context.make()

let use = () => Internal.Context.use(context)

module Trigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="menu-trigger",
    ~dataSize: option<string>=?,
    ~attrs: array<(string, View.attrValue)>=[],
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let isOpen = () => ctx->Option.mapOr(false, ctx => ctx.isOpen())

    let toggle = _ =>
      switch ctx {
      | Some({isOpen, setOpen}) if !disabled => setOpen(!isOpen())
      | _ => ()
      }

    /* ArrowDown opens the menu from the keyboard, as the menu button pattern
       expects. */
    let onKeyDown = event =>
      switch (ctx, Internal.El.eventKey(event)) {
      | (Some({setOpen}), "ArrowDown" | "ArrowUp") if !disabled =>
        Internal.El.preventDefault(event)
        setOpen(true)
      | _ => ()
      }

    <button
      id=?{ctx->Option.map(ctx => ctx.triggerId)->Option.orElse(id)}
      type_="button"
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      ariaExpanded={isOpen}
      disabled
      onClick={toggle}
      onKeyDown={onKeyDown}
      attrs={Array.concat(
        [
          View.attr("aria-haspopup", "menu"),
          View.optionalAttr("aria-controls", ctx->Option.map(ctx => ctx.popupId)),
          View.attr("data-slot", dataSlot),
          View.optionalAttr("data-size", dataSize),
          Internal.flag("data-popup-open", isOpen),
        ],
        attrs,
      )}>
      {children}
    </button>
  }
}

/* A context menu opens at the pointer, not against an element, so the trigger
   also renders a zero-size anchor it moves under the cursor. */
module ContextTrigger = {
  let placeAnchor: (Dom.element, Dom.event) => unit = %raw(`function (anchor, event) {
    anchor.style.position = "fixed"
    anchor.style.left = event.clientX + "px"
    anchor.style.top = event.clientY + "px"
  }`)

  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~dataSlot: string="menu-context-trigger",
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let anchorId = ctx->Option.mapOr(Internal.Id.make("menu-anchor"), ctx => ctx.triggerId)

    let onContextMenu = event =>
      switch ctx {
      | Some({setOpen}) if !disabled =>
        Internal.El.preventDefault(event)
        switch Internal.El.getElementById(anchorId)->Nullable.toOption {
        | Some(anchor) => placeAnchor(anchor, event)
        | None => ()
        }
        setOpen(true)
      | _ => ()
      }

    <div
      id=?{id}
      class=?{className}
      style=?{style}
      onContextMenu={onContextMenu}
      attrs=[View.attr("data-slot", dataSlot)]>
      <span id={anchorId} ariaHidden={true} />
      {children}
    </div>
  }
}

module Item = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~onSelect: option<unit => unit>=?,
    ~closeOnSelect: bool=true,
    ~role: string="menuitem",
    ~dataSlot: string="menu-item",
    ~dataVariant: option<string>=?,
    ~attrs: array<(string, View.attrValue)>=[],
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()

    let select = _ =>
      if !disabled {
        switch onSelect {
        | Some(onSelect) => onSelect()
        | None => ()
        }
        switch ctx {
        | Some({setOpen}) if closeOnSelect => setOpen(false)
        | _ => ()
        }
      }

    <div
      id=?{id}
      role
      tabIndex={-1}
      class=?{className}
      style=?{style}
      onClick={select}
      attrs={Array.concat(
        [
          View.attr("data-slot", dataSlot),
          View.optionalAttr("data-variant", dataVariant),
          View.optionalAttr("aria-disabled", disabled ? Some("true") : None),
          View.optionalAttr("data-disabled", disabled ? Some("") : None),
        ],
        attrs,
      )}>
      {children}
    </div>
  }
}

module CheckboxItem = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~checked: option<MaybeSignal.t<bool>>=?,
    ~defaultChecked: bool=false,
    ~onCheckedChange: option<bool => unit>=?,
    ~disabled: bool=false,
    ~closeOnSelect: bool=true,
    ~dataSlot: string="menu-checkbox-item",
    ~indicatorClassName: option<string>=?,
    ~indicator: View.node=Internal.noChildren,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let state = Internal.Controlled.make(
      ~value=checked,
      ~defaultValue=defaultChecked,
      ~onChange=onCheckedChange,
    )

    let toggle = _ =>
      if !disabled {
        state.set(!state.get())
        switch ctx {
        | Some({setOpen}) if closeOnSelect => setOpen(false)
        | _ => ()
        }
      }

    <div
      id=?{id}
      role="menuitemcheckbox"
      tabIndex={-1}
      class=?{className}
      style=?{style}
      onClick={toggle}
      attrs=[
        Internal.boolAttr("aria-checked", state.get),
        Internal.flag("data-checked", state.get),
        Internal.flag("data-unchecked", () => !state.get()),
        View.attr("data-slot", dataSlot),
        View.optionalAttr("aria-disabled", disabled ? Some("true") : None),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      <span
        class=?{indicatorClassName}
        attrs=[
          View.attr("data-slot", `${dataSlot}-indicator`),
          View.optionalComputedAttr("hidden", () => state.get() ? None : Some("true")),
        ]>
        {indicator}
      </span>
      {children}
    </div>
  }
}

module RadioGroup = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~value: option<MaybeSignal.t<string>>=?,
    ~defaultValue: string="",
    ~onValueChange: option<string => unit>=?,
    ~dataSlot: string="menu-radio-group",
    ~children: View.node=Internal.noChildren,
  ) => {
    let state = Internal.Controlled.make(~value, ~defaultValue, ~onChange=onValueChange)

    <div
      id=?{id}
      role="group"
      class=?{className}
      attrs=[View.attr("data-slot", dataSlot)]>
      {Internal.Context.provide(
        radioContext,
        {selected: state.get, select: state.set},
        children,
      )}
    </div>
  }
}

module RadioItem = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~closeOnSelect: bool=true,
    ~dataSlot: string="menu-radio-item",
    ~indicatorClassName: option<string>=?,
    ~indicator: View.node=Internal.noChildren,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let group = Internal.Context.use(radioContext)
    let isChecked = () => group->Option.mapOr(false, group => group.selected() === value)

    let select = _ =>
      if !disabled {
        switch group {
        | Some({select}) => select(value)
        | None => ()
        }
        switch ctx {
        | Some({setOpen}) if closeOnSelect => setOpen(false)
        | _ => ()
        }
      }

    <div
      id=?{id}
      role="menuitemradio"
      tabIndex={-1}
      class=?{className}
      style=?{style}
      onClick={select}
      attrs=[
        Internal.boolAttr("aria-checked", isChecked),
        Internal.flag("data-checked", isChecked),
        Internal.flag("data-unchecked", () => !isChecked()),
        View.attr("data-slot", dataSlot),
        View.optionalAttr("aria-disabled", disabled ? Some("true") : None),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
      ]>
      <span
        class=?{indicatorClassName}
        attrs=[
          View.attr("data-slot", `${dataSlot}-indicator`),
          View.optionalComputedAttr("hidden", () => isChecked() ? None : Some("true")),
        ]>
        {indicator}
      </span>
      {children}
    </div>
  }
}

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="menu-group",
    ~children: View.node=Internal.noChildren,
  ) =>
    <div id=?{id} role="group" class=?{className} attrs=[View.attr("data-slot", dataSlot)]>
      {children}
    </div>
}

module Label = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="menu-label",
    ~dataInset: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) =>
    <div
      id=?{id}
      class=?{className}
      attrs=[
        View.attr("data-slot", dataSlot),
        View.optionalAttr("data-inset", dataInset),
      ]>
      {children}
    </div>
}

module Separator = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~dataSlot: string="menu-separator",
  ) =>
    <div
      id=?{id}
      role="separator"
      class=?{className}
      attrs=[View.attr("data-slot", dataSlot), View.attr("aria-orientation", "horizontal")]
    />
}

module Popup = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~ariaLabel: option<string>=?,
    ~dataSlot: string="menu-popup",
    ~attrs: array<(string, View.attrValue)>=[],
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let side = Anchored.useSide()

    /* Roving focus across the items, wrapping at both ends. */
    let onKeyDown = event => {
      let key = Internal.El.eventKey(event)
      switch Internal.El.eventCurrentTarget(event)->Nullable.toOption {
      | None => ()
      | Some(popup) =>
        let items = Internal.El.querySelectorAll(
          popup,
          `[role="menuitem"]:not([aria-disabled="true"]), [role="menuitemcheckbox"]:not([aria-disabled="true"]), [role="menuitemradio"]:not([aria-disabled="true"])`,
        )
        let active = Internal.El.activeElement()->Nullable.toOption
        let index =
          active->Option.flatMap(active =>
            items->Array.findIndexOpt(item => item->Internal.El.contains(active))
          )
        let last = items->Array.length - 1

        let move = next =>
          switch items->Array.get(next) {
          | Some(item) =>
            Internal.El.preventDefault(event)
            item->Internal.El.focus
          | None => ()
          }

        switch key {
        | "ArrowDown" => move(index->Option.mapOr(0, index => index === last ? 0 : index + 1))
        | "ArrowUp" => move(index->Option.mapOr(last, index => index === 0 ? last : index - 1))
        | "Home" => move(0)
        | "End" => move(last)
        | "Enter" | " " =>
          switch active {
          | Some(active) =>
            Internal.El.preventDefault(event)
            active->Internal.El.click
          | None => ()
          }
        | _ => ()
        }
      }
    }

    <div
      id=?{ctx->Option.map(ctx => ctx.popupId)->Option.orElse(id)}
      role="menu"
      tabIndex={-1}
      class=?{className}
      style=?{style}
      ariaLabel=?{ariaLabel}
      onKeyDown={onKeyDown}
      attrs={Array.concat(
        [
          View.optionalAttr("aria-labelledby", ctx->Option.map(ctx => ctx.triggerId)),
          View.attr("data-slot", dataSlot),
          View.computedAttr("data-side", () => side()->Anchored.Side.toString),
          View.attr("data-open", ""),
        ],
        attrs,
      )}>
      {children}
    </div>
  }
}

module Positioner = {
  @xote.component
  let make = (
    ~side: Anchored.Side.t=Bottom,
    ~align: Anchored.Align.t=Start,
    ~sideOffset: float=4.,
    ~alignOffset: float=0.,
    ~className: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) =>
    switch use() {
    | Some(ctx) =>
      let onMount = element => {
        let previouslyFocused = Internal.El.activeElement()->Nullable.toOption
        Internal.El.focusFirst(element)

        let stopDismiss = Internal.Dismiss.attach(
          ~ids=[ctx.popupId, ctx.triggerId],
          ~onDismiss=() => ctx.setOpen(false),
        )

        Some(
          () => {
            stopDismiss()
            switch previouslyFocused {
            | Some(element) => element->Internal.El.focus
            | None => ()
            }
          },
        )
      }

      let content = Internal.Context.provide(
        context,
        ctx,
        <Anchored.Positioner
          anchorId={ctx.triggerId}
          side
          align
          sideOffset
          alignOffset
          className={className->Option.getOr("isolate z-50")}
          dataSlot="menu-positioner">
          {children}
        </Anchored.Positioner>,
      )

      Internal.Portal.render(~isOpen=ctx.isOpen, ~children=content, ~onMount)
      Internal.noChildren
    | None => Internal.noChildren
    }
}

/* A submenu is a menu whose trigger is an item of its parent. */
module SubTrigger = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~dataSlot: string="menu-sub-trigger",
    ~dataInset: option<string>=?,
    ~style: option<string>=?,
    ~children: View.node=Internal.noChildren,
  ) => {
    let ctx = use()
    let isOpen = () => ctx->Option.mapOr(false, ctx => ctx.isOpen())

    let open_ = () =>
      switch ctx {
      | Some({setOpen}) if !disabled => setOpen(true)
      | _ => ()
      }

    /* Pointer opens it, ArrowRight opens it from the keyboard, ArrowLeft or
       Escape closes it and hands focus back to the parent menu. */
    let onKeyDown = event =>
      switch (ctx, Internal.El.eventKey(event)) {
      | (Some(_), "ArrowRight" | "Enter" | " ") =>
        Internal.El.preventDefault(event)
        open_()
      | (Some({setOpen}), "ArrowLeft") =>
        Internal.El.preventDefault(event)
        setOpen(false)
      | _ => ()
      }

    <div
      id=?{ctx->Option.map(ctx => ctx.triggerId)->Option.orElse(id)}
      role="menuitem"
      tabIndex={-1}
      class=?{className}
      style=?{style}
      onPointerEnter={_ => open_()}
      onClick={_ => open_()}
      onKeyDown={onKeyDown}
      attrs=[
        View.attr("aria-haspopup", "menu"),
        Internal.boolAttr("aria-expanded", isOpen),
        View.optionalAttr("aria-controls", ctx->Option.map(ctx => ctx.popupId)),
        View.attr("data-slot", dataSlot),
        View.optionalAttr("data-inset", dataInset),
        View.optionalAttr("aria-disabled", disabled ? Some("true") : None),
        View.optionalAttr("data-disabled", disabled ? Some("") : None),
        Internal.flag("data-popup-open", isOpen),
      ]>
      {children}
    </div>
  }
}

module Root = {
  @xote.component
  let make = (
    ~id: option<string>=?,
    ~open_: option<MaybeSignal.t<bool>>=?,
    ~defaultOpen: bool=false,
    ~onOpenChange: option<bool => unit>=?,
    ~modal: bool=true,
    ~children: View.node=Internal.noChildren,
  ) => {
    let elementId = id->Option.getOr(Internal.Id.make("menu"))
    let state = Internal.Controlled.make(
      ~value=open_,
      ~defaultValue=defaultOpen,
      ~onChange=onOpenChange,
    )

    let ctx: Ctx.t = {
      isOpen: state.get,
      setOpen: state.set,
      triggerId: `${elementId}-trigger`,
      popupId: `${elementId}-popup`,
      modal,
    }

    Internal.Context.provide(context, ctx, children)
  }
}

/* A submenu is an independent menu: its own open state, its own popup. */
module Sub = Root
