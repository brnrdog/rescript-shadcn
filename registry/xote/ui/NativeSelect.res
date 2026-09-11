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
  ~value: option<MaybeSignal.t<string>>=?,
  ~disabled: bool=false,
  ~required: bool=false,
  ~ariaLabel: option<string>=?,
  ~invalid: bool=false,
  ~size: Size.t=Default,
  ~onChange: option<Dom.event => unit>=?,
  ~children: View.node=View.fragment([]),
) =>
  <div
    class={cn(
      "cn-native-select-wrapper group/native-select relative w-fit has-[select:disabled]:opacity-50",
      className,
    )}
    attrs=[
      View.attr("data-slot", "native-select-wrapper"),
      View.attr("data-size", (size :> string)),
    ]>
    <select
      id=?{id}
      name=?{name}
      value=?{value}
      disabled
      required
      ariaLabel=?{ariaLabel}
      onChange=?{onChange}
      class="cn-native-select outline-none disabled:pointer-events-none disabled:cursor-not-allowed"
      attrs=[
        View.attr("data-slot", "native-select"),
        View.attr("data-size", (size :> string)),
        View.optionalAttr("aria-invalid", invalid ? Some("true") : None),
      ]>
      {children}
    </select>
    <Icons.ChevronDown
      dataSlot="native-select-icon"
      className="cn-native-select-icon pointer-events-none absolute select-none"
    />
  </div>

module Option = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~value: option<string>=?,
    ~disabled: bool=false,
    ~children: View.node=View.fragment([]),
  ) =>
    <option
      id=?{id}
      value=?{value}
      disabled
      class=?{className}
      attrs=[View.attr("data-slot", "native-select-option")]>
      {children}
    </option>
}

module OptGroup = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~label: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <optgroup
      id=?{id}
      class=?{className}
      attrs=[
        View.attr("data-slot", "native-select-optgroup"),
        View.optionalAttr("label", label),
      ]>
      {children}
    </optgroup>
}
