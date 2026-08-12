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

xote builds real DOM nodes eagerly, so three things React gives a primitive library for free are
provided by `Internal`:

**Context.** JSX wraps component calls in `View.LazyComponent`, evaluated during render — long after
a parent returned. `Context.provide` forces the children subtree while the value is set, which
restores React-like scoping. Content mounted later (a portal) has to re-enter the scope; see
`Dialog.Portal`.

**Element access.** JSX exposes no ref, so a component that needs its own node — to measure
`--accordion-panel-height`, or to focus the first control in a dialog — looks it up by id on the
microtask after mount (`El.withElement`).

**Attribute removal.** This is the load-bearing one. `RuntimeDom.setAttrOrProp` only removes
attributes on a fixed boolean list; everything else is written with `setAttribute`, so a reactive
`data-checked` would be permanently present and a switch would render permanently checked. State
attributes therefore go through an effect bound to the mounted node, which can call
`removeAttribute`. The initial values are also applied untracked while the element is built, so the
first paint is correct rather than one microtask late.

`Internal.Node` exists only because of the last two points, plus the closed JSX attribute
surface — `Elements.props` types four ARIA attributes, and primitives need `aria-controls`,
`aria-labelledby`, `aria-orientation`, `aria-valuenow` and friends. Once xote grows an attribute
escape hatch and treats a `None` attribute value as removal, these components can be written as
plain JSX and `Internal.Node` can go away. The styled layer in `registry/xote` already is plain JSX.

## Development

```bash
yarn workspace rescript-base-xote res:build
yarn test:xote   # jsdom coverage of the primitives, driven through the registry demos
```
