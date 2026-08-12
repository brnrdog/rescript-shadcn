/* Text direction for a subtree. Xote has no provider component: the attribute
   on the wrapper is what CSS and the browser read. */
@xote.component
let make = (
  ~className: option<string>=?,
  ~id: option<string>=?,
  ~direction: string="ltr",
  ~children: View.node=View.fragment([]),
) =>
  <div
    id=?{id}
    class=?{className}
    attrs=[View.attr("dir", direction), View.attr("data-slot", "direction-provider")]>
    {children}
  </div>
