@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* One real input holds the value; the slots are presentation driven by it, so
   paste, autofill and mobile keyboards keep working. */
module Ctx = {
  type t = {
    value: unit => string,
    focused: unit => bool,
    length: int,
  }
}

let context: XoteBase.Internal.Context.t<Ctx.t> = XoteBase.Internal.Context.make()

let inputValue: Dom.event => string = %raw(`function (event) { return event.target.value || "" }`)

/* The input is one field behind all the slots, so the caret has to sit at the
   end of the value: pressing a slot otherwise leaves it at position 0, where
   typing prepends and backspace eats the first digit instead of the last. */
let caretToEnd: Dom.event => unit = %raw(`function (event) {
  const input = event.currentTarget
  const end = (input.value || "").length
  requestAnimationFrame(() => { try { input.setSelectionRange(end, end) } catch (_) {} })
}`)

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~name: option<string>=?,
  ~length: int=6,
  ~maxLength: option<int>=?,
  ~pattern: option<string>=?,
  ~required: bool=false,
  ~value: option<MaybeSignal.t<string>>=?,
  ~defaultValue: string="",
  ~onValueChange: option<string => unit>=?,
  ~onComplete: option<string => unit>=?,
  ~disabled: bool=false,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) => {
  let length = maxLength->Option.getOr(length)
  let state = XoteBase.Internal.Controlled.make(~value, ~defaultValue, ~onChange=onValueChange)
  let focused = Signal.make(false)

  let onInput = event => {
    let next = inputValue(event)->String.slice(~start=0, ~end=length)
    state.set(next)
    switch onComplete {
    | Some(onComplete) if next->String.length === length => onComplete(next)
    | _ => ()
    }
  }

  <div
    id=?{id}
    class={cn("cn-input-otp relative flex items-center has-disabled:opacity-50", className)}
    attrs=[View.attr("data-slot", "input-otp")]>
    <input
      name=?{name}
      value={MaybeSignal.computed(state.get)}
      disabled
      required
      ariaLabel=?{ariaLabel}
      autoComplete="one-time-code"
      onInput={event => {
        onInput(event)
        caretToEnd(event)
      }}
      onClick={caretToEnd}
      onKeyUp={caretToEnd}
      onFocus={event => {
        Signal.set(focused, true)
        caretToEnd(event)
      }}
      onBlur={_ => Signal.set(focused, false)}
      class="cn-input-otp-input absolute inset-0 z-20 cursor-text opacity-0 disabled:cursor-not-allowed"
      attrs=[
        View.attr("data-slot", "input-otp-input"),
        View.optionalAttr("pattern", pattern),
        View.attr(
          "inputmode",
          pattern->Option.mapOr("numeric", _ => "text"),
        ),
        View.attr("maxlength", length->Int.toString),
      ]
    />
    {XoteBase.Internal.Context.provide(
      context,
      {value: state.get, focused: () => Signal.get(focused), length},
      children,
    )}
  </div>
}

module Group = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn("cn-input-otp-group flex items-center", className)}
      attrs=[View.attr("data-slot", "input-otp-group")]>
      {children}
    </div>
}

module Slot = {
  @xote.component
  let make = (~index: int, ~className: option<string>=?, ~id: option<string>=?) => {
    let ctx = XoteBase.Internal.Context.use(context)

    let char = () =>
      switch ctx {
      | Some(ctx) => ctx.value()->String.charAt(index)
      | None => ""
      }

    let isActive = () =>
      switch ctx {
      | Some(ctx) => ctx.focused() && ctx.value()->String.length === index
      | None => false
      }

    <div
      id=?{id}
      class={cn(
        "cn-input-otp-slot relative flex items-center justify-center data-[active=true]:z-10",
        className,
      )}
      attrs=[
        View.attr("data-slot", "input-otp-slot"),
        View.computedAttr("data-active", () => isActive() ? "true" : "false"),
      ]>
      {View.signalText(char)}
      {View.tracked(() =>
        isActive()
          ? <div
              class="cn-input-otp-caret pointer-events-none absolute inset-0 flex items-center justify-center">
              <div class="cn-input-otp-caret-line animate-caret-blink" />
            </div>
          : View.fragment([])
      )}
    </div>
  }
}

module Separator = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?) =>
    <div
      id=?{id}
      role="separator"
      class={cn("cn-input-otp-separator flex items-center", className)}
      attrs=[View.attr("data-slot", "input-otp-separator")]>
      <Icons.Minus />
    </div>
}
