// @vitest-environment jsdom
import { beforeEach, describe, expect, it } from "vitest"

// The xote registry renders real DOM nodes, so the components can be mounted
// and driven directly — no React, no renderer.
import { mount } from "xote/src/View.res.mjs"
import { make as AccordionDemo } from "rescript-shadcn-xote/examples/AccordionDemo.res.mjs"
import { make as CheckboxDemo } from "rescript-shadcn-xote/examples/CheckboxDemo.res.mjs"
import { make as DialogDemo } from "rescript-shadcn-xote/examples/DialogDemo.res.mjs"
import { make as SwitchDemo } from "rescript-shadcn-xote/examples/SwitchDemo.res.mjs"
import { make as TabsDemo } from "rescript-shadcn-xote/examples/TabsDemo.res.mjs"

/** State attributes are applied by effects bound to the mounted node, which run
 *  on the microtask queue. */
const flush = async () => {
  await Promise.resolve()
  await Promise.resolve()
}

const render = async (component: (props: {}) => unknown) => {
  const container = document.createElement("div")
  document.body.appendChild(container)
  mount(component({}), container)
  await flush()
  return container
}

const query = (root: ParentNode, selector: string) => {
  const element = root.querySelector(selector)
  if (!element) throw new Error(`No element matched ${selector}`)
  return element as HTMLElement
}

beforeEach(() => {
  document.body.innerHTML = ""
})

describe("Switch", () => {
  it("toggles the presence-based state attributes the styles select on", async () => {
    const container = await render(SwitchDemo)
    const root = query(container, '[data-slot="switch"]')
    const thumb = query(container, '[data-slot="switch-thumb"]')

    expect(root.getAttribute("role")).toBe("switch")
    expect(root.getAttribute("aria-checked")).toBe("false")
    expect(root.hasAttribute("data-unchecked")).toBe(true)
    expect(root.hasAttribute("data-checked")).toBe(false)
    expect(thumb.hasAttribute("data-unchecked")).toBe(true)

    root.click()
    await flush()

    expect(root.getAttribute("aria-checked")).toBe("true")
    expect(root.hasAttribute("data-checked")).toBe(true)
    expect(root.hasAttribute("data-unchecked")).toBe(false)
    expect(thumb.hasAttribute("data-checked")).toBe(true)
  })

  it("is labelled by the demo's label", async () => {
    const container = await render(SwitchDemo)
    const label = query(container, "label")

    expect(label.getAttribute("for")).toBe("airplane-mode")
    expect(query(container, '[data-slot="switch"]').id).toBe("airplane-mode")
  })
})

describe("Checkbox", () => {
  it("mounts the indicator only while checked", async () => {
    const container = await render(CheckboxDemo)
    const [unchecked, checked] = Array.from(
      container.querySelectorAll('[data-slot="checkbox"]')
    ) as HTMLElement[]

    expect(unchecked.querySelector('[data-slot="checkbox-indicator"]')).toBeNull()
    expect(checked.querySelector('[data-slot="checkbox-indicator"]')).not.toBeNull()

    unchecked.click()
    await flush()

    expect(unchecked.getAttribute("aria-checked")).toBe("true")
    expect(unchecked.querySelector('[data-slot="checkbox-indicator"]')).not.toBeNull()
  })

  it("ignores clicks while disabled", async () => {
    const container = await render(CheckboxDemo)
    const disabled = query(container, '[data-slot="checkbox"][data-disabled]') as HTMLButtonElement

    // Not just the data attribute: the control is really disabled, so the
    // `disabled:` style variants apply and it leaves the tab order.
    expect(disabled.disabled).toBe(true)
    expect(disabled.hasAttribute("disabled")).toBe(true)

    disabled.click()
    await flush()

    expect(disabled.getAttribute("aria-checked")).toBe("false")
  })
})

describe("Accordion", () => {
  it("wires triggers to panels and keeps one item open at a time", async () => {
    const container = await render(AccordionDemo)
    const [first, second] = Array.from(
      container.querySelectorAll('[data-slot="accordion-trigger"]')
    ) as HTMLElement[]
    const firstPanel = document.getElementById(first.getAttribute("aria-controls")!)!
    const secondPanel = document.getElementById(second.getAttribute("aria-controls")!)!

    expect(firstPanel.getAttribute("aria-labelledby")).toBe(first.id)
    expect(first.getAttribute("aria-expanded")).toBe("true")
    expect(firstPanel.hasAttribute("hidden")).toBe(false)
    expect(secondPanel.hasAttribute("hidden")).toBe(true)

    second.click()
    await flush()

    expect(second.getAttribute("aria-expanded")).toBe("true")
    expect(first.getAttribute("aria-expanded")).toBe("false")
    expect(secondPanel.hasAttribute("hidden")).toBe(false)
    expect(secondPanel.hasAttribute("data-open")).toBe(true)
  })

  it("moves focus between triggers with the arrow keys", async () => {
    const container = await render(AccordionDemo)
    const triggers = Array.from(
      container.querySelectorAll('[data-slot="accordion-trigger"]')
    ) as HTMLElement[]

    triggers[0].focus()
    triggers[0].dispatchEvent(
      new window.KeyboardEvent("keydown", { key: "ArrowDown", bubbles: true })
    )

    expect(document.activeElement).toBe(triggers[1])
  })
})

describe("Tabs", () => {
  it("selects a panel and hides the others", async () => {
    const container = await render(TabsDemo)
    const [overview, analytics] = Array.from(
      container.querySelectorAll('[role="tab"]')
    ) as HTMLElement[]
    const overviewPanel = document.getElementById(overview.getAttribute("aria-controls")!)!
    const analyticsPanel = document.getElementById(analytics.getAttribute("aria-controls")!)!

    expect(overview.getAttribute("aria-selected")).toBe("true")
    expect(overview.getAttribute("tabindex")).toBe("0")
    expect(analytics.getAttribute("tabindex")).toBe("-1")
    expect(analyticsPanel.hasAttribute("hidden")).toBe(true)

    analytics.click()
    await flush()

    expect(analytics.hasAttribute("data-active")).toBe(true)
    expect(overviewPanel.hasAttribute("hidden")).toBe(true)
    expect(analyticsPanel.hasAttribute("hidden")).toBe(false)
  })
})

describe("Dialog", () => {
  it("portals the popup into the body and closes on Escape", async () => {
    const container = await render(DialogDemo)
    const trigger = query(container, '[data-slot="dialog-trigger"]')

    expect(document.querySelector('[role="dialog"]')).toBeNull()
    expect(trigger.getAttribute("aria-expanded")).toBe("false")

    trigger.click()
    await flush()

    const popup = query(document, '[role="dialog"]')
    expect(popup.closest("[data-xote-portal]")?.parentElement).toBe(document.body)
    expect(popup.getAttribute("aria-modal")).toBe("true")
    expect(popup.getAttribute("aria-labelledby")).toBe(
      query(document, '[data-slot="dialog-title"]').id
    )
    expect(trigger.getAttribute("aria-expanded")).toBe("true")

    document.dispatchEvent(new window.KeyboardEvent("keydown", { key: "Escape", bubbles: true }))
    await flush()

    expect(document.querySelector('[role="dialog"]')).toBeNull()
  })

  it("closes when the close button is pressed", async () => {
    const container = await render(DialogDemo)
    query(container, '[data-slot="dialog-trigger"]').click()
    await flush()

    query(document, '[data-slot="dialog-close"]').click()
    await flush()

    expect(document.querySelector('[role="dialog"]')).toBeNull()
  })
})
