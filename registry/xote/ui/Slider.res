@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Orientation = XoteBase.Internal.Orientation

@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~name: option<string>=?,
  ~value: option<MaybeSignal.t<array<float>>>=?,
  ~defaultValue: array<float>=[0.],
  ~onValueChange: option<array<float> => unit>=?,
  ~min: float=0.,
  ~max: float=100.,
  ~step: float=1.,
  ~disabled: bool=false,
  ~ariaLabel: option<string>=?,
  ~orientation: Orientation.t=Horizontal,
) =>
  <XoteBase.Slider.Root
    ?id
    ?name
    ?value
    defaultValue
    ?onValueChange
    min
    max
    step
    disabled
    ?ariaLabel
    orientation
    dataSlot="slider"
    className={cn(
      "cn-slider relative flex w-full touch-none items-center select-none data-horizontal:w-full data-vertical:h-full data-vertical:w-auto data-vertical:flex-col data-disabled:opacity-50",
      className,
    )}>
    <XoteBase.Slider.Track
      dataSlot="slider-track"
      className="cn-slider-track relative grow overflow-hidden select-none">
      <XoteBase.Slider.Range
        dataSlot="slider-range"
        className="cn-slider-range select-none data-horizontal:h-full data-vertical:w-full"
      />
    </XoteBase.Slider.Track>
    <XoteBase.Slider.Thumbs dataSlot="slider-thumb" className="cn-slider-thumb" />
  </XoteBase.Slider.Root>
