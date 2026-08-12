@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Size = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("sm") Sm
}

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
  ~size: Size.t=Default,
) =>
  <XoteBase.Switch.Root
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
    dataSlot="switch"
    dataSize={(size :> string)}
    className={cn(
      "cn-switch peer group/switch relative inline-flex items-center transition-all outline-none after:absolute after:-inset-x-3 after:-inset-y-2 data-disabled:cursor-not-allowed data-disabled:opacity-50",
      className,
    )}>
    <XoteBase.Switch.Thumb
      dataSlot="switch-thumb"
      className="cn-switch-thumb pointer-events-none block ring-0 transition-transform"
    />
  </XoteBase.Switch.Root>
