@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* Sonner's behaviour, not just its look: the newest toast sits at the front of
   a collapsed stack, the ones behind it peek out and shrink, and hovering the
   stack expands it into a list. */

module Position = {
  @unboxed
  type t =
    | @as("top-left") TopLeft
    | @as("top-right") TopRight
    | @as("bottom-left") BottomLeft
    | @as("bottom-right") BottomRight
    | @as("top-center") TopCenter
    | @as("bottom-center") BottomCenter
}

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("success") Success
    | @as("info") Info
    | @as("warning") Warning
    | @as("error") Error
}

module Action = {
  type t = {
    label: string,
    onClick: unit => unit,
  }
}

module Options = {
  type t = {
    description?: string,
    action?: Action.t,
    position?: Position.t,
    duration?: int,
  }
}

type toast = {
  id: string,
  message: string,
  description: option<string>,
  action: option<Action.t>,
  variant: Variant.t,
}

/* Newest first: index 0 is the front of the stack. */
let toasts: Signal.t<array<toast>> = Signal.make([])

let defaultDuration = 4000

let dismiss = (id: string) =>
  Signal.set(toasts, Signal.peek(toasts)->Array.filter(toast => toast.id !== id))

let push = (message: string, ~variant: Variant.t, ~options: option<Options.t>) => {
  let id = XoteBase.Internal.Id.make("toast")
  let entry = {
    id,
    message,
    description: options->Option.flatMap(options => options.description),
    action: options->Option.flatMap(options => options.action),
    variant,
  }
  Signal.set(toasts, Array.concat([entry], Signal.peek(toasts)))

  let duration = options->Option.flatMap(options => options.duration)->Option.getOr(defaultDuration)
  if duration > 0 {
    XoteBase.Internal.El.setTimer(() => dismiss(id), duration)->ignore
  }
  id
}

let toast = (message, ~options=?) => push(message, ~variant=Default, ~options)
let success = (message, ~options=?) => push(message, ~variant=Success, ~options)
let info = (message, ~options=?) => push(message, ~variant=Info, ~options)
let warning = (message, ~options=?) => push(message, ~variant=Warning, ~options)
let error = (message, ~options=?) => push(message, ~variant=Error, ~options)

let icon = (variant: Variant.t) =>
  switch variant {
  | Success => <Icons.CircleCheck className="size-4" />
  | Info => <Icons.Info className="size-4" />
  | Warning => <Icons.TriangleAlert className="size-4" />
  | Error => <Icons.CircleAlert className="size-4" />
  | Default => View.fragment([])
  }

module Toaster = {
  /* Each toast reports its height so the stack can offset the ones behind it
     without guessing. */
  let measure: (Dom.element, string => unit) => unit = %raw(`function (el, report) {
    const send = () => report(Math.round(el.getBoundingClientRect().height) + "px")
    send()
    if (typeof ResizeObserver !== "undefined") {
      const observer = new ResizeObserver(send)
      observer.observe(el)
    }
  }`)

  @xote.component
  let make = (
    ~className: option<string>=?,
    ~position: Position.t=BottomRight,
    ~visibleToasts: int=3,
    ~closeButton: bool=false,
    ~richColors: bool=false,
    ~expand: bool=false,
    ~ariaLabel: string="Notifications",
  ) => {
    let expanded = Signal.make(expand)
    let heights: Dict.t<string> = Dict.make()
    let bumped = Signal.make(0)

    let isTop = switch position {
    | TopLeft | TopRight | TopCenter => true
    | _ => false
    }

    let placement = switch position {
    | TopLeft => "top-0 left-0 items-start"
    | TopRight => "top-0 right-0 items-end"
    | TopCenter => "top-0 left-1/2 -translate-x-1/2 items-center"
    | BottomLeft => "bottom-0 left-0 items-start"
    | BottomRight => "bottom-0 right-0 items-end"
    | BottomCenter => "bottom-0 left-1/2 -translate-x-1/2 items-center"
    }

    /* Collapsed, each toast behind the front one peeks out and shrinks;
       expanded, they lay out as a list using the measured heights. */
    let offsetFor = index => {
      let _ = Signal.get(bumped)
      let direction = isTop ? 1. : -1.
      if Signal.get(expanded) {
        let stacked =
          Signal.get(toasts)
          ->Array.slice(~start=0, ~end=index)
          ->Array.reduce(0., (total, toast) =>
            total +.
            heights
            ->Dict.get(toast.id)
            ->Option.flatMap(height => height->String.replace("px", "")->Float.fromString)
            ->Option.getOr(64.) +. 12.
          )
        `translateY(${(stacked *. direction)->Float.toString}px)`
      } else {
        let peek = index->Int.toFloat *. 14. *. direction
        let scale = 1. -. index->Int.toFloat *. 0.05
        `translateY(${peek->Float.toString}px) scale(${scale->Float.toString})`
      }
    }

    <ol
      ariaLabel
      class={cn(
        `cn-toast-viewport pointer-events-none fixed z-[100] flex w-full max-w-sm flex-col p-4 ${placement}`,
        className,
      )}
      onPointerEnter={_ => Signal.set(expanded, true)}
      onPointerLeave={_ => Signal.set(expanded, expand)}
      attrs=[
        View.attr("data-slot", "toaster"),
        View.attr("data-position", (position :> string)),
        View.attr("role", "region"),
        XoteBase.Internal.flag("data-expanded", () => Signal.get(expanded)),
        View.optionalAttr("data-rich-colors", richColors ? Some("true") : None),
      ]>
      <View.For
        each={MaybeSignal.reactive(toasts)}
        by={toast => toast.id}
        render={toast => {
          let index = () =>
            Signal.get(toasts)->Array.findIndexOpt(entry => entry.id === toast.id)->Option.getOr(0)

          let elementId = `${toast.id}-item`
          XoteBase.Internal.El.withElement(elementId, element =>
            measure(element, height => {
              heights->Dict.set(toast.id, height)
              Signal.set(bumped, Signal.peek(bumped) + 1)
            })
          )

          <li
            id={elementId}
            role="status"
            class="cn-toast group/toast pointer-events-auto absolute flex w-full items-start gap-3 rounded-lg border bg-popover p-4 text-popover-foreground shadow-lg transition-all duration-300 ease-out"
            style={() =>
              `transform: ${offsetFor(index())}; z-index: ${(100 - index())->Int.toString}; opacity: ${index() >=
                  visibleToasts
                  ? "0"
                  : "1"}`}
            attrs=[
              View.attr("data-slot", "toast"),
              View.attr("data-variant", (toast.variant :> string)),
              View.attr("aria-live", "polite"),
              View.computedAttr("data-index", () => index()->Int.toString),
              XoteBase.Internal.flag("data-front", () => index() === 0),
            ]>
            {toast.variant === Default ? View.fragment([]) : icon(toast.variant)}
            <div class="flex min-w-0 flex-1 flex-col gap-1">
              <div class="cn-toast-title text-sm font-medium" attrs=[View.attr("data-slot", "toast-title")]>
                {toast.message}
              </div>
              {switch toast.description {
              | Some(description) =>
                <div
                  class="cn-toast-description text-muted-foreground text-sm"
                  attrs=[View.attr("data-slot", "toast-description")]>
                  {description}
                </div>
              | None => View.fragment([])
              }}
            </div>
            {switch toast.action {
            | Some(action) =>
              <Button
                size=Sm
                dataSlot="toast-action"
                className="cn-toast-action shrink-0"
                onClick={_ => {
                  action.onClick()
                  dismiss(toast.id)
                }}>
                {action.label}
              </Button>
            | None => View.fragment([])
            }}
            {closeButton
              ? <Button
                  variant=Ghost
                  size=IconXs
                  ariaLabel="Close"
                  dataSlot="toast-close"
                  className="cn-toast-close shrink-0"
                  onClick={_ => dismiss(toast.id)}>
                  <Icons.X />
                </Button>
              : View.fragment([])}
          </li>
        }}
      />
    </ol>
  }
}
