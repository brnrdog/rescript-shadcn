@xote.component
let make = () => {
  let value = Signal.make(33.)

  <div class="flex w-full max-w-sm flex-col gap-3">
    <Slider
      value={MaybeSignal.reactive(value)}
      onValueChange={next => Signal.set(value, next)}
      max=100.
      step=1.
      ariaLabel="Volume"
    />
    <span class="text-muted-foreground text-sm tabular-nums">
      {"Volume: "}
      {Signal.get(value)->Float.toString}
    </span>
  </div>
}
