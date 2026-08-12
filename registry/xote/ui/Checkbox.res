@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~name: option<string>=?,
  ~checked: option<MaybeSignal.t<bool>>=?,
  ~defaultChecked: bool=false,
  ~onCheckedChange: option<bool => unit>=?,
  ~disabled: bool=false,
  ~required: bool=false,
  ~readOnly: bool=false,
  ~ariaLabel: option<string>=?,
  ~ariaInvalid: option<bool>=?,
) =>
  <BaseXote.Checkbox.Root
    ?id
    ?name
    ?checked
    defaultChecked
    ?onCheckedChange
    disabled
    required
    readOnly
    ?ariaLabel
    ?ariaInvalid
    dataSlot="checkbox"
    className={cn(
      "cn-checkbox peer relative shrink-0 outline-none after:absolute after:-inset-x-3 after:-inset-y-2 disabled:cursor-not-allowed disabled:opacity-50",
      className,
    )}>
    <BaseXote.Checkbox.Indicator
      dataSlot="checkbox-indicator"
      className="cn-checkbox-indicator grid place-content-center text-current transition-none">
      <Icons.Check />
    </BaseXote.Checkbox.Indicator>
  </BaseXote.Checkbox.Root>
