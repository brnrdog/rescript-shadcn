/* Shared plumbing for the xote-base primitives.

   Components declare their own markup, including presence-toggled state
   attributes, through the JSX `attrs` escape hatch:

     attrs=[View.optionalComputedAttr("data-open", () => open_() ? Some("") : None)]

   What is left here is what xote has no equivalent for: context (JSX defers
   component calls, so a provider forces its subtree while the value is set),
   access to a mounted node (there is no ref, and a panel has to measure itself),
   and portals. */

module Orientation = {
  @unboxed
  type t =
    | @as("horizontal") Horizontal
    | @as("vertical") Vertical

  let toString = (orientation: t) => (orientation :> string)
}

/* JSX passes children as a plain node — a fragment when there are several — so
   components take a node with this default rather than an option. */
let noChildren: View.node = View.fragment([])

/* True when a caller actually passed something. An omitted `children` prop is
   an empty fragment, and it may not be the `noChildren` value itself: a wrapper
   forwarding its own default builds a fresh one. */
let hasChildren = (children: View.node): bool =>
  switch children {
  | View.Fragment([]) => false
  | View.Text("") => false
  | _ => true
  }

/* Presence-based styling (`[data-open]`, `[data-checked]`) needs the attribute
   gone, not empty, when the state is off. */
let flag = (name: string, isOn: unit => bool): (string, View.attrValue) =>
  View.optionalComputedAttr(name, () => isOn() ? Some("") : None)

let boolAttr = (name: string, value: unit => bool): (string, View.attrValue) =>
  View.computedAttr(name, () => value() ? "true" : "false")

module Id = {
  let counter = ref(0)

  let make = (prefix: string): string => {
    counter := counter.contents + 1
    `${prefix}-${counter.contents->Int.toString}`
  }
}

module Context = {
  type t<'a> = {mutable current: option<'a>}

  let make = (): t<'a> => {current: None}

  /* Evaluate every deferred component in the subtree right now.

     JSX wraps component calls in `View.LazyComponent`, which render evaluates
     later — long after a provider returned. Forcing the subtree while the
     context value is set restores React-like scoping: children read the value
     during their own evaluation. Reactive nodes (`SignalFragment`, `KeyedList`)
     are produced on signal updates and stay deferred, so a provider value read
     inside one must be captured beforehand. */
  let rec force = (node: View.node): View.node =>
    switch node {
    | View.LazyComponent(fn) => force(fn())
    | View.Element({tag, attrs, events, children}) =>
      View.Element({tag, attrs, events, children: children->Array.map(force)})
    | View.Fragment(children) => View.Fragment(children->Array.map(force))
    | View.Keyed({key, identity, child}) => View.Keyed({key, identity, child: force(child)})
    | node => node
    }

  let provide = (context: t<'a>, value: 'a, children: View.node): View.node => {
    let previous = context.current
    context.current = Some(value)
    let forced = force(children)
    context.current = previous
    forced
  }

  let use = (context: t<'a>): option<'a> => context.current
}

module El = {
  type style

  @val @scope("document")
  external getElementById: string => Nullable.t<Dom.element> = "getElementById"

  @send external closest: (Dom.element, string) => Nullable.t<Dom.element> = "closest"
  @send external focus: Dom.element => unit = "focus"
  @send external click: Dom.element => unit = "click"
  @send external contains: (Dom.element, Dom.element) => bool = "contains"
  @get external textContent: Dom.element => string = "textContent"
  @send
  external addEventListener: (Dom.element, string, Dom.event => unit) => unit = "addEventListener"
  @send external setAttribute: (Dom.element, string, string) => unit = "setAttribute"
  @send external removeAttribute: (Dom.element, string) => unit = "removeAttribute"
  @send external hasAttribute: (Dom.element, string) => bool = "hasAttribute"
  @get external scrollHeight: Dom.element => int = "scrollHeight"
  @get external style: Dom.element => style = "style"
  @send external setProperty: (style, string, string) => unit = "setProperty"

  @val @scope("document") external createElement: string => Dom.element = "createElement"
  @send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
  @send external remove: Dom.element => unit = "remove"

  let isBrowser: bool = %raw(`typeof document !== "undefined"`)

  /* `globalThis.` matters: these shadow the globals they call. */
  let setTimer: (unit => unit, int) => int = %raw(`function (fn, delay) {
    return globalThis.setTimeout(fn, delay)
  }`)

  let clearTimer: int => unit = %raw(`function (id) { globalThis.clearTimeout(id) }`)

  let animationDuration: Dom.element => int = %raw(`function (el) {
    const style = getComputedStyle(el)
    const duration = (style.animationDuration || "0s").split(",")[0].trim()
    const value = parseFloat(duration) || 0
    return Math.round(duration.endsWith("ms") ? value : value * 1000)
  }`)

  let schedule: (unit => unit) => unit = %raw(`function (fn) {
    if (typeof queueMicrotask === "function") { queueMicrotask(fn) }
    else if (typeof setTimeout === "function") { setTimeout(fn, 0) }
  }`)

  let querySelectorAll: (Dom.element, string) => array<Dom.element> = %raw(`function (el, selector) {
    return Array.prototype.slice.call(el.querySelectorAll(selector))
  }`)

  let eventTarget: Dom.event => Nullable.t<Dom.element> = %raw(`function (event) {
    return event.target
  }`)

  /* The element the handler is attached to — a keyboard handler on a root can
     reach its own subtree without an id lookup. */
  let eventCurrentTarget: Dom.event => Nullable.t<Dom.element> = %raw(`function (event) {
    return event.currentTarget
  }`)

  let eventKey: Dom.event => string = %raw(`function (event) { return event.key || "" }`)

  let preventDefault: Dom.event => unit = %raw(`function (event) { event.preventDefault() }`)

  let body: unit => Nullable.t<Dom.element> = %raw(`function () {
    return typeof document === "undefined" ? null : document.body
  }`)

  let activeElement: unit => Nullable.t<Dom.element> = %raw(`function () {
    return typeof document === "undefined" ? null : document.activeElement
  }`)

  let onWindow: (string, unit => unit) => unit => unit = %raw(`function (type, handler) {
    if (typeof window === "undefined") { return function () {} }
    window.addEventListener(type, handler, true)
    return function () { window.removeEventListener(type, handler, true) }
  }`)

  let onDocument: (string, Dom.event => unit) => unit => unit = %raw(`function (type, handler) {
    if (typeof document === "undefined") { return function () {} }
    document.addEventListener(type, handler, true)
    return function () { document.removeEventListener(type, handler, true) }
  }`)

  /* Xote's JSX has no `load` / `error` events, and preloading is what Radix and
     Base UI do anyway: the browser serves the real <img> from cache. */
  let preloadImage: (string, unit => unit, unit => unit) => unit = %raw(`function (src, onLoad, onError) {
    if (typeof Image === "undefined") { return }
    const image = new Image()
    image.onload = onLoad
    image.onerror = onError
    image.src = src
  }`)

  /* A hidden element measures 0, and a panel has to know its natural height
     while closed — that is the value its opening animation grows into. Reveal,
     measure and re-hide within one synchronous block, so no frame is painted in
     between. */
  let measureHeight = (element: Dom.element): int => {
    let wasHidden = element->hasAttribute("hidden")
    if wasHidden {
      element->removeAttribute("hidden")
    }
    let height = element->scrollHeight
    if wasHidden {
      element->setAttribute("hidden", "")
    }
    height
  }

  let focusFirst = (container: Dom.element): unit => {
    let focusable = querySelectorAll(
      container,
      `[autofocus], button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])`,
    )
    switch focusable->Array.get(0) {
    | Some(element) => element->focus
    | None => container->focus
    }
  }

  /* xote 7.1.0 keeps its renderer's owner machinery internal and no longer
     serves those modules from the package's exports map, so a subtree this
     package mounted itself is torn down here, against the `__xote_owner__`
     property the owner system documents. Without it a portal that closes
     leaves its content's effects running. */
  type ownerRecord = {disposers: array<unit => unit>, computeds: array<Signal.t<unknown>>}

  let readOwner: Dom.element => Nullable.t<ownerRecord> = %raw(`function (element) {
    return element["__xote_owner__"] ?? null
  }`)

  let elementChildren: Dom.element => array<Dom.element> = %raw(`function (element) {
    return Array.prototype.filter.call(element.childNodes, node => node.nodeType === 1)
  }`)

  let rec disposeSubtree = (element: Dom.element): unit => {
    element->elementChildren->Array.forEach(disposeSubtree)

    switch element->readOwner->Nullable.toOption {
    | Some(owner) =>
      owner.disposers->Array.forEach(dispose => dispose())
      owner.computeds->Array.forEach(Computed.dispose)
    | None => ()
    }
  }

  /* Cleanups for work that runs after render. An effect created while a
     component renders belongs to that component, so one registered here is
     disposed with it; work deferred to a later mount has no such scope, and
     collects into the slot that was opened for it instead. */
  type slot = {mutable cleanups: array<unit => unit>}

  let currentSlot: ref<option<slot>> = ref(None)

  let openSlot = (): slot => {
    let slot = {cleanups: []}
    Effect.run(() => Some(
      () => {
        slot.cleanups->Array.forEach(cleanup => cleanup())
        slot.cleanups = []
      },
    ))
    slot
  }

  let runInSlot = (slot: option<slot>, fn: unit => unit): unit => {
    let previous = currentSlot.contents
    currentSlot := slot
    fn()
    currentSlot := previous
  }

  /* An effect created while a component body is evaluating can lose its own
     subscription: in development xote evaluates those bodies inside a
     `Computed.make` — its hidden-read probe — and an effect created inside a
     computed never re-runs, so the thing it drives simply stops updating.
     Creating it one microtask later puts it outside that computation, and the
     slot opened here keeps it owned by the component either way. */
  let ownedEffect = (
    body: unit => option<unit => unit>,
    ~alsoDispose: option<unit => unit>=?,
  ): unit => {
    let slot = openSlot()
    schedule(() => {
      let disposer = Effect.runWithDisposer(body)
      slot.cleanups->Array.push(disposer.dispose)->ignore
      switch alsoDispose {
      | Some(dispose) => slot.cleanups->Array.push(dispose)->ignore
      | None => ()
      }
    })
  }

  let ownDisposer = (disposer: Effect.disposer): unit =>
    switch currentSlot.contents {
    | Some(slot) => slot.cleanups->Array.push(disposer.dispose)->ignore
    | None => Effect.run(() => Some(disposer.dispose))
    }

  /* Work bound to a node by id. Portaled content is built long before it is
     mounted, and a portal mounts a *new* node every time it opens, so this is a
     standing binding rather than a one-shot lookup. */
  type binding = {
    id: string,
    fn: Dom.element => unit,
    slot: slot,
    mutable last: option<Dom.element>,
  }

  let bindings: array<binding> = []

  let runOwned = (fn, slot, element) => runInSlot(Some(slot), () => fn(element))

  /* Run every binding whose node is in the document and is not the one it last
     ran against — that covers both the first mount and each reopen. */
  let flushPending = (): unit =>
    bindings->Array.forEach(binding =>
      switch (getElementById(binding.id)->Nullable.toOption, binding.last) {
      | (None, _) => ()
      | (Some(element), Some(previous)) if element === previous => ()
      | (Some(element), _) =>
        binding.last = Some(element)
        runOwned(binding.fn, binding.slot, element)
      }
    )

  /* Stands in for a ref: run `fn` against the node rendered for `id`, owned by
     the component that is currently rendering, so effects created inside are
     disposed with it. */
  let withElement = (id: string, fn: Dom.element => unit): unit =>
    if isBrowser {
      bindings
      ->Array.push({id, fn, slot: openSlot(), last: None})
      ->ignore
      schedule(flushPending)
    }
}

/* Open/closed panels (accordion, collapsible) share one behaviour: expose the
   natural height as a CSS variable so the keyframes can animate to it, and stay
   in the layout until the exit animation finished.

   The markup owns `data-open` / `data-closed`; this owns the measurement and
   the delayed `hidden`, both of which need the mounted node. */
module Panel = {
  type t = {isHidden: unit => bool}

  let make = (~id: string, ~cssVariable: string, ~isOpen: unit => bool): t => {
    let hidden = Signal.make(!isOpen())

    El.withElement(id, element => {
      let first = ref(true)
      let closeTimeout = ref(None)

      let cancelPendingClose = () =>
        switch closeTimeout.contents {
        | Some(timeoutId) =>
          El.clearTimer(timeoutId)
          closeTimeout := None
        | None => ()
        }

      let disposer = Effect.runWithDisposer(() => {
        let open_ = isOpen()
        let isFirstRun = first.contents
        first := false

        cancelPendingClose()
        element->El.style->El.setProperty(
          cssVariable,
          `${element->El.measureHeight->Int.toString}px`,
        )

        if open_ {
          Signal.set(hidden, false)
        } else if isFirstRun {
          Signal.set(hidden, true)
        } else {
          closeTimeout :=
            Some(
              El.setTimer(() => {
                closeTimeout := None
                if !isOpen() {
                  Signal.set(hidden, true)
                }
              }, element->El.animationDuration),
            )
        }

        None
      })

      El.ownDisposer(disposer)
      El.ownDisposer({dispose: cancelPendingClose})
    })

    {isHidden: () => Signal.get(hidden)}
  }

  /* `hidden` is a boolean attribute: "true" sets it, anything else removes it. */
  let hiddenAttr = (panel: t): (string, View.attrValue) =>
    View.optionalComputedAttr("hidden", () => panel.isHidden() ? Some("true") : None)
}

/* Overlay content lives at the end of `document.body` so it escapes any
   `overflow` or stacking context of the trigger's ancestors. Xote has no portal
   node, so the subtree is mounted into a container element that is created on
   open and disposed on close. */
module Portal = {
  let render = (
    ~isOpen: unit => bool,
    ~children: View.node,
    ~onMount: option<Dom.element => option<unit => unit>>=?,
  ): unit =>
    if El.isBrowser {
      let container: ref<option<Dom.element>> = ref(None)
      let teardown: ref<option<unit => unit>> = ref(None)

      let close = () => {
        switch teardown.contents {
        | Some(dispose) => dispose()
        | None => ()
        }
        teardown := None

        switch container.contents {
        | Some(element) =>
          El.disposeSubtree(element)
          element->El.remove
        | None => ()
        }
        container := None
      }

      El.ownedEffect(~alsoDispose=close, () => {
        if isOpen() {
          switch (container.contents, El.body()->Nullable.toOption) {
          | (None, Some(body)) =>
            let element = El.createElement("div")
            element->El.setAttribute("data-xote-portal", "")
            body->El.appendChild(element)
            View.mount(children, element)
            container := Some(element)
            /* The subtree is in the document now, so anything waiting on a node
               inside it can run. */
            El.flushPending()
            teardown :=
              switch onMount {
              | Some(onMount) => onMount(element)
              | None => None
              }
          | _ => ()
          }
        } else {
          close()
        }
        None
      })
    }
}

/* `MaybeSignal` props let a caller hand over either a plain value or a signal.
   Controlled components read the incoming value, uncontrolled ones own a
   signal; both end up behind the same getter/setter pair. */
module Controlled = {
  type t<'a> = {
    get: unit => 'a,
    set: 'a => unit,
  }

  let make = (
    ~value: option<MaybeSignal.t<'a>>,
    ~defaultValue: 'a,
    ~onChange: option<'a => unit>,
  ): t<'a> => {
    switch value {
    | Some(value) => {
        get: () => MaybeSignal.get(value),
        set: next =>
          switch onChange {
          | Some(onChange) => onChange(next)
          | None => ()
          },
      }
    | None => {
        let signal = Signal.make(defaultValue)
        {
          get: () => Signal.get(signal),
          set: next => {
            Signal.set(signal, next)
            switch onChange {
            | Some(onChange) => onChange(next)
            | None => ()
            }
          },
        }
      }
    }
  }
}

/* Overlays close on Escape and on a pointer press outside of themselves. Both
   listen on the document, so they are attached when the overlay mounts and
   removed with it. */
module Dismiss = {
  let attach = (~ids: array<string>, ~onDismiss: unit => unit, ~escape: bool=true): (unit => unit) => {
    let isInside = target =>
      ids->Array.some(id =>
        switch El.getElementById(id)->Nullable.toOption {
        | Some(element) => element->El.contains(target)
        | None => false
        }
      )

    let removePointerDown = El.onDocument("pointerdown", event =>
      switch El.eventTarget(event)->Nullable.toOption {
      | Some(target) if !isInside(target) => onDismiss()
      | _ => ()
      }
    )

    let removeKeyDown = escape
      ? El.onDocument("keydown", event =>
          if El.eventKey(event) === "Escape" {
            El.preventDefault(event)
            onDismiss()
          }
        )
      : () => ()

    () => {
      removePointerDown()
      removeKeyDown()
    }
  }
}
