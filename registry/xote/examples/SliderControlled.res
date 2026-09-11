@xote.component
let make = () => {
  let value = Signal.make([0.3, 0.7])

  <div class="mx-auto grid w-full max-w-xs gap-3">
    <div class="flex items-center justify-between gap-2">
      <Label for_="slider-demo-temperature"> {"Temperature"} </Label>
      <span class="text-muted-foreground text-sm">
        {View.signalText(() =>
          Signal.get(value)->Array.map(v => Float.toString(v))->Array.join(", ")
        )}
      </span>
    </div>
    <Slider
      id="slider-demo-temperature"
      value={MaybeSignal.reactive(value)}
      onValueChange={next => Signal.set(value, next)}
      min={0.}
      max={1.}
      step={0.1}
    />
  </div>
}
