@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* Native overflow with styled scrollbars: no measurement, no custom thumb to
   keep in sync with the content. */
@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~ariaLabel: option<string>=?,
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    class={cn("cn-scroll-area relative", className)}
    attrs=[View.attr("data-slot", "scroll-area")]>
    <div
      tabIndex={0}
      ariaLabel=?{ariaLabel}
      class="cn-scroll-area-viewport focus-visible:ring-ring/50 size-full overflow-auto rounded-[inherit] transition-[color,box-shadow] outline-none focus-visible:ring-[3px] focus-visible:outline-1 [scrollbar-color:var(--border)_transparent] [scrollbar-width:thin]"
      attrs=[View.attr("data-slot", "scroll-area-viewport")]>
      {children}
    </div>
  </div>
