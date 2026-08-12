@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~type_: string="text",
  ~name: option<string>=?,
  ~value: option<MaybeSignal.t<string>>=?,
  ~placeholder: option<string>=?,
  ~disabled: bool=false,
  ~required: bool=false,
  ~readOnly: bool=false,
  ~autoComplete: option<string>=?,
  ~ariaLabel: option<string>=?,
  ~onInput: option<Dom.event => unit>=?,
  ~onChange: option<Dom.event => unit>=?,
) =>
  <input
    id=?{id}
    type_
    name=?{name}
    value=?{value}
    placeholder=?{placeholder}
    disabled
    required
    readOnly
    autoComplete=?{autoComplete}
    ariaLabel=?{ariaLabel}
    onInput=?{onInput}
    onChange=?{onChange}
    class={cn(
      "cn-input file:text-foreground placeholder:text-muted-foreground w-full min-w-0 outline-none file:inline-flex file:border-0 file:bg-transparent disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50",
      className,
    )}
    attrs=[View.attr("data-slot", "input")]
  />
