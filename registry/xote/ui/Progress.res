@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~value: option<MaybeSignal.t<option<float>>>=?,
  ~min: float=0.,
  ~max: float=100.,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <XoteBase.Progress.Root
    ?id
    ?value
    min
    max
    ?ariaLabel
    dataSlot="progress"
    className={cn("cn-progress-root flex flex-wrap gap-3", className)}>
    {children}
    <XoteBase.Progress.Track
      dataSlot="progress-track"
      className="cn-progress-track relative flex w-full items-center overflow-x-hidden">
      <XoteBase.Progress.Indicator
        dataSlot="progress-indicator" className="cn-progress-indicator h-full transition-all"
      />
    </XoteBase.Progress.Track>
  </XoteBase.Progress.Root>

module Label = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <XoteBase.Progress.Label
      ?id dataSlot="progress-label" className={cn("cn-progress-label", className)}>
      {children}
    </XoteBase.Progress.Label>
}

module Value = {
  @xote.component
  let make = (~className: option<string>=?, ~id: option<string>=?, ~children: View.node=View.fragment([])) =>
    <XoteBase.Progress.Value
      ?id children dataSlot="progress-value" className={cn("cn-progress-value", className)}
    />
}
