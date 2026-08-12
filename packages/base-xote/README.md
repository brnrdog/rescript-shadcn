# base-xote

Headless UI primitives for ReScript, built on [xote](https://xote.dev/)'s fine-grained
reactivity. They are the xote counterpart of `rescript-base-ui`: behaviour, ARIA wiring and
keyboard interaction, no styling.

The primitives emit the same attribute contract as [Base UI](https://base-ui.com/) —
`data-checked` / `data-unchecked`, `data-open` / `data-closed`, `data-disabled`, `data-active` —
so the shadcn styles in [rescript-shadcn](https://rescript-shadcn.miriad.studio/) apply unchanged.
That contract is presence-based (`data-checked:bg-primary` compiles to `[data-checked]`), which
shapes most of the implementation notes below.

Styled components built on these live in `registry/xote` and are distributed with the shadcn CLI:

```bash
npx shadcn@latest add @rescript-shadcn/Switch
```

## Components

| Primitive | Parts |
| --- | --- |
| `Accordion` | `Root`, `Item`, `Header`, `Trigger`, `Panel` |
| `Avatar` | `Root`, `Image`, `Fallback` |
| `Checkbox` | `Root`, `Indicator` |
| `Collapsible` | `Root`, `Trigger`, `Panel` |
| `Dialog` | `Root`, `Trigger`, `Portal`, `Backdrop`, `Popup`, `Title`, `Description`, `Close` |
| `Progress` | `Root`, `Track`, `Indicator`, `Label`, `Value` |
| `RadioGroup` | `Root`, `Item`, `Indicator` |
| `Separator` | — |
| `Switch` | `Root`, `Thumb` |
| `Tabs` | `Root`, `List`, `Tab`, `Panel` |
| `Toggle` | — |

Each accepts an optional controlled value (`MaybeSignal.t<_>`) alongside a `default*` prop, mirroring
Base UI:

```rescript
let checked = Signal.make(false)

<BaseXote.Switch.Root
  checked={MaybeSignal.reactive(checked)}
  onCheckedChange={next => Signal.set(checked, next)}>
  <BaseXote.Switch.Thumb />
</BaseXote.Switch.Root>
```

## How it works

Components are plain Xote JSX. Presence-toggled state attributes — the ones the
shadcn styles select on — are declared with the `attrs` escape hatch, where a
`None` value removes the attribute rather than writing an empty one:

```rescript
<button
  role="switch"
  ariaLabel=?{ariaLabel}
  disabled
  onClick={toggle}
  attrs=[
    Internal.boolAttr("aria-checked", state.get),
    Internal.flag("data-checked", state.get),
    Internal.flag("data-unchecked", () => !state.get()),
  ]>
```

Both are xote 7.1.0-beta.8 features. Before them the primitives had to build
elements outside JSX and apply state through an effect bound to the mounted
node; that layer is gone.

What `Internal` still provides is what xote has no equivalent for:

**Context.** JSX wraps component calls in `View.LazyComponent`, evaluated during
render — long after a parent returned. `Context.provide` forces the children
subtree while the value is set, which restores React-like scoping. Content
mounted later (a portal) has to re-enter the scope; see `Dialog.Portal`.

**Element access.** There is no ref, so the two components that must read their
own node look it up by id on the microtask after mount (`El.withElement`): a
disclosure panel measuring the height its animation grows into, and a dialog
focusing its first control. A panel measures by revealing, reading and
re-hiding within one synchronous block, since a hidden element measures zero.

**Portals.** Overlay content is mounted into a container appended to
`document.body` and disposed on close.

One smaller gap remains: `Elements.props` has no `load` / `error` events, so
`Avatar.Image` preloads through an `Image()` instead — which is what Radix and
Base UI do anyway, since the browser then serves the real `<img>` from cache.

## Development

```bash
yarn workspace rescript-base-xote res:build
yarn test:xote   # jsdom coverage of the primitives, driven through the registry demos
```
