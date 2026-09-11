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

@module("xote/src/Computed.res.mjs")
external disposeComputed: 'a => unit = "dispose"

/* xote 7.1.0 made the renderer's owner machinery internal and stopped serving
   it from the package's exports, so the demo host tears down the subtree it
   mounted itself, against the `__xote_owner__` property the owner system
   documents. Without it, switching demos leaves the previous one's effects
   running. */
let disposeElement: (Dom.element, 'a => unit) => unit = %raw(`function (root, disposeComputed) {
  const stack = [root]
  while (stack.length > 0) {
    const node = stack.pop()
    const owner = node["__xote_owner__"]
    if (owner) {
      owner.disposers.forEach(dispose => dispose())
      owner.computeds.forEach(disposeComputed)
    }
    for (const child of node.childNodes) {
      if (child.nodeType === 1) { stack.push(child) }
    }
  }
}`)

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
        disposeElement(container, disposeComputed)
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
