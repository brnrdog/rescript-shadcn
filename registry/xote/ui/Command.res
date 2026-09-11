@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* A filterable command list. Items register their searchable text, and the
   query hides the ones that do not match. */
module Ctx = {
  type t = {
    query: unit => string,
    setQuery: string => unit,
    matches: string => bool,
    register: string => unit,
    visibleCount: unit => int,
  }
}

let context: XoteBase.Internal.Context.t<Ctx.t> = XoteBase.Internal.Context.make()

let use = () => XoteBase.Internal.Context.use(context)

let inputValue: Dom.event => string = %raw(`function (event) { return event.target.value || "" }`)

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) => {
  let query = Signal.make("")
  let items = []

  let matches = value => {
    let needle = Signal.get(query)->String.trim->String.toLowerCase
    needle === "" || value->String.toLowerCase->String.includes(needle)
  }

  <div
    id=?{id}
    ariaLabel=?{ariaLabel}
    class={cn("cn-command flex size-full flex-col overflow-hidden", className)}
    attrs=[View.attr("data-slot", "command")]>
    {XoteBase.Internal.Context.provide(
      context,
      {
        query: () => Signal.get(query),
        setQuery: next => Signal.set(query, next),
        matches,
        register: value => items->Array.push(value)->ignore,
        visibleCount: () => items->Array.filter(matches)->Array.length,
      },
      children,
    )}
  </div>
}

module Input = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~placeholder: string="Type a command or search...",
  ) => {
    let ctx = use()

    <div
      class="cn-command-input-wrapper flex items-center gap-2"
      attrs=[View.attr("data-slot", "command-input-wrapper")]>
      <Icons.Search className="cn-command-input-icon size-4 shrink-0 opacity-50" />
      <input
        id=?{id}
        type_="text"
        placeholder
        value={MaybeSignal.computed(() => ctx->Option.mapOr("", ctx => ctx.query()))}
        onInput={event =>
          switch ctx {
          | Some({setQuery}) => setQuery(inputValue(event))
          | None => ()
          }}
        class={cn(
          "cn-command-input flex-1 bg-transparent outline-hidden disabled:cursor-not-allowed disabled:opacity-50",
          className,
        )}
        attrs=[View.attr("data-slot", "command-input"), View.attr("role", "combobox")]
      />
    </div>
  }
}

module List = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      role="listbox"
      class={cn("cn-command-list max-h-72 overflow-y-auto overflow-x-hidden", className)}
      attrs=[View.attr("data-slot", "command-list")]>
      {children}
    </div>
}

module Item = {
  @xote.component
  let make = (
    /* cmdk filters on the item's rendered text; passing `value` overrides it. */
    ~value: option<string>=?,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~onSelect: option<unit => unit>=?,
    ~children: View.node=View.fragment([]),
  ) => {
    let ctx = use()
    let elementId = id->Option.getOr(XoteBase.Internal.Id.make("command-item"))

    let searchText = () =>
      switch value {
      | Some(value) => value
      | None =>
        XoteBase.Internal.El.getElementById(elementId)
        ->Nullable.toOption
        ->Option.mapOr("", XoteBase.Internal.El.textContent)
      }

    let isVisible = () => ctx->Option.mapOr(true, ctx => ctx.matches(searchText()))

    switch (ctx, value) {
    | (Some({register}), Some(value)) => register(value)
    | _ => ()
    }

    <div
      id={elementId}
      role="option"
      tabIndex={-1}
      class={cn(
        "cn-command-item group/command-item data-[disabled=true]:pointer-events-none data-[disabled=true]:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}
      onClick={_ =>
        switch onSelect {
        | Some(onSelect) if !disabled => onSelect()
        | _ => ()
        }}
      attrs=[
        View.attr("data-slot", "command-item"),
        View.optionalAttr("data-value", value),
        View.computedAttr("data-disabled", () => disabled ? "true" : "false"),
        View.optionalComputedAttr("hidden", () => isVisible() ? None : Some("true")),
      ]>
      {children}
    </div>
  }
}

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~heading: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      role="group"
      class={cn("cn-command-group", className)}
      attrs=[View.attr("data-slot", "command-group")]>
      {switch heading {
      | Some(heading) =>
        <div
          class="cn-command-group-heading text-muted-foreground px-2 py-1.5 text-xs font-medium"
          attrs=[View.attr("data-slot", "command-group-heading")]>
          {heading}
        </div>
      | None => View.fragment([])
      }}
      {children}
    </div>
}

module Empty = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) => {
    let ctx = use()

    /* Items register their searchable text as they mount, so "nothing matched"
       is a count rather than a DOM query. */
    let isEmpty = () => ctx->Option.mapOr(false, ctx => ctx.visibleCount() === 0)

    <div
      id=?{id}
      role="presentation"
      class={cn("cn-command-empty py-6 text-center text-sm", className)}
      attrs=[
        View.attr("data-slot", "command-empty"),
        View.optionalComputedAttr("hidden", () => isEmpty() ? None : Some("true")),
      ]>
      {children}
    </div>
  }
}

module Separator = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <Separator ?id dataSlot="command-separator" className={cn("cn-command-separator", className)} />
}

module Shortcut = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <span
      id=?{id}
      class={cn("cn-command-shortcut ml-auto", className)}
      attrs=[View.attr("data-slot", "command-shortcut")]>
      {children}
    </span>
}
