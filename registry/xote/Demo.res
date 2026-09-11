/* Demos are mounted by the docs site, which needs a uniform entry point:
   every example module exposes `make` taking an empty props record. */
module Props = {
  type t = {}
}

module type Component = {
  let make: Props.t => View.node
}
