@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

module Variant = {
  @unboxed
  type t =
    | @as("default") Default
    | @as("destructive") Destructive
}

type toast = {
  id: string,
  title: string,
  description: option<string>,
  variant: Variant.t,
}

/* One store for the whole app, so `Toast.add` works from anywhere without a
   provider in scope. */
let toasts: Signal.t<array<toast>> = Signal.make([])

let dismiss = (id: string) =>
  Signal.set(toasts, Signal.peek(toasts)->Array.filter(toast => toast.id !== id))

let add = (~title: string, ~description: option<string>=?, ~variant: Variant.t=Default, ~duration: int=5000) => {
  let id = XoteBase.Internal.Id.make("toast")
  Signal.set(toasts, Array.concat(Signal.peek(toasts), [{id, title, description, variant}]))
  if duration > 0 {
    XoteBase.Internal.El.setTimer(() => dismiss(id), duration)->ignore
  }
  id
}

module Item = {
  @xote.component
  let make = (
    ~toast: toast,
    ~className: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <li
      role="status"
      class={cn(
        "cn-toast group/toast pointer-events-auto flex w-full items-start gap-3 border bg-popover text-popover-foreground shadow-lg outline-none",
        className,
      )}
      attrs=[
        View.attr("data-slot", "toast"),
        View.attr("data-variant", (toast.variant :> string)),
        View.attr("aria-live", "polite"),
      ]>
      <div class="flex min-w-0 flex-1 flex-col gap-1">
        <div
          class="cn-toast-title text-sm font-medium"
          attrs=[View.attr("data-slot", "toast-title")]>
          {toast.title}
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
        {children}
      </div>
      <Button
        variant=Ghost
        size=IconXs
        ariaLabel="Close"
        dataSlot="toast-close"
        className="cn-toast-close shrink-0"
        onClick={_ => dismiss(toast.id)}>
        <Icons.X />
      </Button>
    </li>
}

module Toaster = {
  @xote.component
  let make = (~className: option<string>=?, ~ariaLabel: string="Notifications") =>
    <ol
      ariaLabel
      class={cn(
        "cn-toast-viewport pointer-events-none fixed right-0 bottom-0 z-[100] flex w-full max-w-sm flex-col gap-3 p-4",
        className,
      )}
      attrs=[View.attr("data-slot", "toast-viewport"), View.attr("role", "region")]>
      <View.For
        each={MaybeSignal.reactive(toasts)}
        by={toast => toast.id}
        render={toast => <Item toast className="rounded-lg p-4" />}
      />
    </ol>
}
