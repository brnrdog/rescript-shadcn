@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~name: option<string>=?,
  ~value: option<MaybeSignal.t<string>>=?,
  ~placeholder: option<string>=?,
  ~disabled: bool=false,
  ~required: bool=false,
  ~readOnly: bool=false,
  ~rows: option<int>=?,
  ~ariaLabel: option<string>=?,
  ~dataSlot: string="textarea",
  ~onInput: option<Dom.event => unit>=?,
  ~onChange: option<Dom.event => unit>=?,
) =>
  <textarea
    id=?{id}
    name=?{name}
    value=?{value}
    placeholder=?{placeholder}
    disabled
    required
    readOnly
    rows=?{rows}
    ariaLabel=?{ariaLabel}
    onInput=?{onInput}
    onChange=?{onChange}
    class={cn(
      "cn-textarea flex field-sizing-content min-h-16 w-full outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50",
      className,
    )}
    attrs=[View.attr("data-slot", dataSlot)]
  />
