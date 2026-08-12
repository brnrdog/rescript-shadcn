@@directive("'use client'")

/* Bridge for the xote registry: its demos are not React components, they build
   DOM nodes. Mount one into a container React owns, and dispose it — releasing
   the effects xote registered on those nodes — when React unmounts. */

type node

type demoProps = {}

type component = demoProps => node

type loader = unit => promise<component>

@module("xote/src/View.res.mjs")
external mount: (node, Dom.element) => unit = "mount"

@module("xote/src/View.res.mjs") @scope("Render")
external disposeElement: Dom.element => unit = "disposeElement"

@send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"

let clear: Dom.element => unit = %raw(`function (container) {
  while (container.firstChild) { container.removeChild(container.firstChild) }
}`)

@react.component
let make = (~load: loader) => {
  let containerRef = React.useRef(Nullable.null)

  React.useEffect1(() => {
    let cancelled = ref(false)

    let cleanup = () =>
      switch containerRef.current->Nullable.toOption {
      | Some(container) =>
        container->disposeElement
        container->clear
      | None => ()
      }

    load()
    ->Promise.thenResolve(component =>
      switch (cancelled.contents, containerRef.current->Nullable.toOption) {
      | (false, Some(container)) =>
        cleanup()
        mount(component({}), container)
      | _ => ()
      }
    )
    ->Promise.ignore

    Some(
      () => {
        cancelled := true
        cleanup()
      },
    )
  }, [load])

  <div ref={ReactDOM.Ref.domRef(containerRef)} className="contents" />
}
