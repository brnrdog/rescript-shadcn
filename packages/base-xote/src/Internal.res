/* Shared plumbing for the base-xote primitives.

   Xote builds real DOM nodes eagerly, so the pieces React gives you for free —
   context, refs, mount callbacks — are provided here instead:

   - `Context` gives parent/child components a dynamically scoped value by
     forcing the children subtree while the value is set.
   - `El` gives access to the mounted DOM node (looked up by id) so attributes
     can be *removed*, not just re-valued. Presence-based selectors such as
     `data-open:` or `data-checked:` need removal to behave like Base UI.
*/

module Orientation = {
  @unboxed
  type t =
    | @as("horizontal") Horizontal
    | @as("vertical") Vertical

  let toString = (orientation: t) => (orientation :> string)
}

/* Identity sentinel for an omitted `children` prop. JSX passes children as a
   plain node (a fragment when there are several), so components take a node
   with this default rather than an option. */
let noChildren: View.node = View.fragment([])

/* True when a caller actually passed something. An omitted `children` prop is
   an empty fragment, and it may not be the `noChildren` value itself — a
   wrapper component forwarding its own default builds a fresh one. */
let hasChildren = (children: View.node): bool =>
  switch children {
  | View.Fragment([]) => false
  | View.Text("") => false
  | _ => true
  }

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

module Data = {
  /* Values in a `data` bag are handed to the JSX runtime untyped: a string is
     applied once, a `unit => string` becomes a reactive attribute. */
  type value = Obj.t

  let str = (value: string): value => Obj.magic(value)

  let compute = (fn: unit => string): value => Obj.magic(fn)

  let make = (entries: array<(string, value)>): Obj.t =>
    entries->Dict.fromArray->Obj.magic

  let flag = (name: string, enabled: bool): option<(string, value)> =>
    enabled ? Some((name, str(""))) : None

  let optional = (entries: array<option<(string, value)>>): Obj.t =>
    entries->Array.filterMap(entry => entry)->make
}

module El = {
  type style

  @val @scope("document")
  external getElementById: string => Nullable.t<Dom.element> = "getElementById"

  @send external setAttribute: (Dom.element, string, string) => unit = "setAttribute"
  @send external removeAttribute: (Dom.element, string) => unit = "removeAttribute"
  @send external getAttribute: (Dom.element, string) => Nullable.t<string> = "getAttribute"
  @send external matches: (Dom.element, string) => bool = "matches"
  @send external closest: (Dom.element, string) => Nullable.t<Dom.element> = "closest"
  @send external querySelector: (Dom.element, string) => Nullable.t<Dom.element> = "querySelector"
  @send external focus: Dom.element => unit = "focus"
  @send external click: Dom.element => unit = "click"
  @send external contains: (Dom.element, Dom.element) => bool = "contains"
  @send
  external addEventListener: (Dom.element, string, Dom.event => unit) => unit = "addEventListener"
  @send
  external removeEventListener: (Dom.element, string, Dom.event => unit) => unit =
    "removeEventListener"
  @get external scrollHeight: Dom.element => int = "scrollHeight"
  @get external offsetWidth: Dom.element => int = "offsetWidth"
  @get external offsetHeight: Dom.element => int = "offsetHeight"
  @get external style: Dom.element => style = "style"
  @send external setProperty: (style, string, string) => unit = "setProperty"
  @send external removeProperty: (style, string) => unit = "removeProperty"

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

  let eventKey: Dom.event => string = %raw(`function (event) { return event.key || "" }`)

  let preventDefault: Dom.event => unit = %raw(`function (event) { event.preventDefault() }`)

  let stopPropagation: Dom.event => unit = %raw(`function (event) { event.stopPropagation() }`)

  /* Run `fn` against the mounted node for `id`, owned by the component that is
     currently rendering so effects created inside are disposed with it. */
  let withElement = (id: string, fn: Dom.element => unit): unit =>
    if isBrowser {
      let owner = View.Reactivity.currentOwner.contents
      schedule(() =>
        switch getElementById(id)->Nullable.toOption {
        | Some(element) =>
          switch owner {
          | Some(owner) => View.Reactivity.runWithOwner(owner, () => fn(element))
          | None => fn(element)
          }
        | None => ()
        }
      )
    }

  /* Reactively apply attributes to a mounted node. `None` removes. */
  let bindAttributes = (id: string, compute: unit => array<(string, option<string>)>): unit =>
    withElement(id, element => {
      let disposer = Effect.runWithDisposer(() => {
        compute()->Array.forEach(((name, value)) =>
          switch value {
          | Some(value) => element->setAttribute(name, value)
          | None => element->removeAttribute(name)
          }
        )
        None
      })

      switch View.Reactivity.currentOwner.contents {
      | Some(owner) => View.Reactivity.addDisposer(owner, disposer)
      | None => ()
      }
    })

  let setFlag = (element: Dom.element, name: string, enabled: bool): unit =>
    enabled ? element->setAttribute(name, "") : element->removeAttribute(name)

  @val @scope("document") external createElement: string => Dom.element = "createElement"
  @send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
  @send external remove: Dom.element => unit = "remove"

  let body: unit => Nullable.t<Dom.element> = %raw(`function () {
    return typeof document === "undefined" ? null : document.body
  }`)

  let activeElement: unit => Nullable.t<Dom.element> = %raw(`function () {
    return typeof document === "undefined" ? null : document.activeElement
  }`)

  let onDocument: (string, Dom.event => unit) => unit => unit = %raw(`function (type, handler) {
    if (typeof document === "undefined") { return function () {} }
    document.addEventListener(type, handler, true)
    return function () { document.removeEventListener(type, handler, true) }
  }`)

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
}

/* Overlay content lives at the end of `document.body` so it escapes any
   `overflow` or stacking context of the trigger's ancestors. Xote has no
   portal node, so the subtree is mounted into a container element that is
   created on open and disposed on close. */
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
          View.Render.disposeElement(element)
          element->El.remove
        | None => ()
        }
        container := None
      }

      let disposer = Effect.runWithDisposer(() => {
        if isOpen() {
          switch (container.contents, El.body()->Nullable.toOption) {
          | (None, Some(body)) =>
            let element = El.createElement("div")
            element->El.setAttribute("data-xote-portal", "")
            body->El.appendChild(element)
            View.mount(children, element)
            container := Some(element)
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

      switch View.Reactivity.currentOwner.contents {
      | Some(owner) =>
        View.Reactivity.addDisposer(owner, disposer)
        View.Reactivity.addDisposer(owner, {dispose: close})
      | None => ()
      }
    }
}

/* The JSX runtime only types a fixed set of HTML attributes, and primitives
   need arbitrary ones (`aria-controls`, `aria-orientation`, `role`, …), so they
   build their elements through this instead of JSX. */
module Node = {
  let make = (
    ~tag: string,
    ~attrs: array<(string, option<string>)>=[],
    ~reactiveAttrs: array<(string, unit => string)>=[],
    ~events: array<(string, Dom.event => unit)>=[],
    ~children: View.node=noChildren,
  ): View.node =>
    View.Element({
      tag,
      attrs: Array.concat(
        attrs->Array.filterMap(((name, value)) =>
          value->Option.map(value => View.attr(name, value))
        ),
        reactiveAttrs->Array.map(((name, compute)) => View.computedAttr(name, compute)),
      ),
      events,
      children: View.childrenToArray(Some(children)),
    })

  /* State attributes are applied twice on purpose: once untracked while the
     element is built, so the first paint is already correct, and then through
     an effect bound to the mounted node, which can also remove them. */
  let stateful = (
    ~tag: string,
    ~id: string,
    ~attrs: array<(string, option<string>)>=[],
    ~reactiveAttrs: array<(string, unit => string)>=[],
    ~state: unit => array<(string, option<string>)>,
    ~events: array<(string, Dom.event => unit)>=[],
    ~children: View.node=noChildren,
  ): View.node => {
    let initial = Signal.untrack(state)
    El.bindAttributes(id, state)
    make(
      ~tag,
      ~attrs=Array.concat([("id", Some(id))], Array.concat(attrs, initial)),
      ~reactiveAttrs,
      ~events,
      ~children,
    )
  }
}

/* Open/closed panels (accordion, collapsible) share one behaviour: keep the
   node mounted, expose its natural height as a CSS variable so the keyframes
   can animate to it, and only hide it once the exit animation finished. */
module Panel = {
  let bind = (~id: string, ~cssVariable: string, ~isOpen: unit => bool): unit =>
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

        if open_ {
          element->El.removeAttribute("hidden")
          element->El.style->El.setProperty(cssVariable, `${element->El.scrollHeight->Int.toString}px`)
          element->El.setFlag("data-open", true)
          element->El.setFlag("data-closed", false)
        } else {
          element->El.style->El.setProperty(cssVariable, `${element->El.scrollHeight->Int.toString}px`)
          element->El.setFlag("data-open", false)
          element->El.setFlag("data-closed", true)

          if isFirstRun {
            element->El.setAttribute("hidden", "")
          } else {
            let hide = () => {
              closeTimeout := None
              if !isOpen() {
                element->El.setAttribute("hidden", "")
              }
            }
            /* Keep the node visible for the exit animation, then hide it so it
               stops taking up space and leaves the tab order. */
            closeTimeout := Some(El.setTimer(hide, element->El.animationDuration))
          }
        }

        None
      })

      switch View.Reactivity.currentOwner.contents {
      | Some(owner) =>
        View.Reactivity.addDisposer(owner, disposer)
        View.Reactivity.addDisposer(owner, {dispose: cancelPendingClose})
      | None => ()
      }
    })
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

let classNames = (values: array<option<string>>): string =>
  values
  ->Array.filterMap(value =>
    switch value {
    | Some("") | None => None
    | Some(value) => Some(value)
    }
  )
  ->Array.join(" ")
