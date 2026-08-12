@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~name: option<string>=?,
  ~value: option<MaybeSignal.t<string>>=?,
  ~defaultValue: string="",
  ~onValueChange: option<string => unit>=?,
  ~disabled: bool=false,
  ~required: bool=false,
  ~readOnly: bool=false,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.RadioGroup.Root
    ?id
    ?name
    ?value
    defaultValue
    ?onValueChange
    disabled
    required
    readOnly
    ?ariaLabel
    dataSlot="radio-group"
    className={cn("cn-radio-group w-full", className)}>
    {children}
  </XoteBase.RadioGroup.Root>

module Item = {
  @xote.component
  let make = (
    ~value: string,
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~disabled: bool=false,
    ~ariaLabel: option<string>=?,
    ~ariaInvalid: option<bool>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <XoteBase.RadioGroup.Item
      value
      ?id
      disabled
      ?ariaLabel
      ?ariaInvalid
      dataSlot="radio-group-item"
      className={cn(
        "cn-radio-group-item group/radio-group-item peer relative aspect-square shrink-0 border outline-none after:absolute after:-inset-x-3 after:-inset-y-2 disabled:cursor-not-allowed disabled:opacity-50",
        className,
      )}>
      <XoteBase.RadioGroup.Indicator
        dataSlot="radio-group-indicator" className="cn-radio-group-indicator">
        <span class="cn-radio-group-indicator-icon" />
      </XoteBase.RadioGroup.Indicator>
      {children}
    </XoteBase.RadioGroup.Item>
}
