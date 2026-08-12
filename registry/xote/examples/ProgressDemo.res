@xote.component
let make = () => {
  let progress = Signal.make(Some(13.))

  let _ = setTimeout(() => Signal.set(progress, Some(66.)), 500)

  <Progress value={MaybeSignal.reactive(progress)} className="w-[60%]" />
}
