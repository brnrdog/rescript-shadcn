// @vitest-environment jsdom
import { beforeEach, describe, expect, it } from "vitest"

// The xote registry renders real DOM nodes, so the components can be mounted
// and driven directly — no React, no renderer.
import { mount } from "xote/src/View.res.mjs"
import { make as AccordionDemo } from "rescript-shadcn-xote/examples/AccordionDemo.res.mjs"
import { make as CheckboxDemo } from "rescript-shadcn-xote/examples/CheckboxDemo.res.mjs"
import { make as DialogDemo } from "rescript-shadcn-xote/examples/DialogDemo.res.mjs"
import { make as PopoverDemo } from "rescript-shadcn-xote/examples/PopoverDemo.res.mjs"
import { make as SwitchDemo } from "rescript-shadcn-xote/examples/SwitchDemo.res.mjs"
import { make as TooltipDemo } from "rescript-shadcn-xote/examples/TooltipDemo.res.mjs"
import { make as TabsDemo } from "rescript-shadcn-xote/examples/TabsDemo.res.mjs"

/** State attributes are applied by effects bound to the mounted node, which run
 *  on the microtask queue. */
const flush = async () => {
  await Promise.resolve()
  await Promise.resolve()
}

/** The styled tooltip opens on a delay, so hover assertions have to outwait it. */
const wait = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

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

describe("Popover", () => {
  it("portals the content, wires it to the trigger and closes on Escape", async () => {
    const container = await render(PopoverDemo)
    const trigger = query(container, '[data-slot="popover-trigger"]')

    expect(trigger.getAttribute("aria-expanded")).toBe("false")
    expect(document.querySelector('[data-slot="popover-content"]')).toBeNull()

    trigger.click()
    await flush()

    const content = query(document, '[data-slot="popover-content"]')
    expect(content.closest("[data-xote-portal]")?.parentElement).toBe(document.body)
    expect(trigger.getAttribute("aria-controls")).toBe(content.id)
    expect(trigger.getAttribute("aria-expanded")).toBe("true")
    // The positioner resolves a side, which the enter animation styles select on.
    expect(content.getAttribute("data-side")).toMatch(/top|bottom|left|right/)

    document.dispatchEvent(new window.KeyboardEvent("keydown", { key: "Escape", bubbles: true }))
    await flush()

    expect(document.querySelector('[data-slot="popover-content"]')).toBeNull()
  })

  it("closes on a press outside and stays open on a press inside", async () => {
    const container = await render(PopoverDemo)
    query(container, '[data-slot="popover-trigger"]').click()
    await flush()

    const content = query(document, '[data-slot="popover-content"]')
    content.dispatchEvent(new window.MouseEvent("pointerdown", { bubbles: true }))
    await flush()
    expect(document.querySelector('[data-slot="popover-content"]')).not.toBeNull()

    document.body.dispatchEvent(new window.MouseEvent("pointerdown", { bubbles: true }))
    await flush()
    expect(document.querySelector('[data-slot="popover-content"]')).toBeNull()
  })
})

describe("Tooltip", () => {
  it("opens on hover, describes the trigger and closes on leave", async () => {
    const container = await render(TooltipDemo)
    const trigger = container.querySelectorAll('[data-slot="tooltip-trigger"]')[0] as HTMLElement

    trigger.dispatchEvent(new window.MouseEvent("mouseenter", { bubbles: true }))
    await wait(250)

    const content = query(document, '[data-slot="tooltip-content"]')
    expect(content.getAttribute("role")).toBe("tooltip")
    expect(trigger.getAttribute("aria-describedby")).toBe(content.id)

    trigger.dispatchEvent(new window.MouseEvent("mouseleave", { bubbles: true }))
    await flush()

    expect(document.querySelector('[data-slot="tooltip-content"]')).toBeNull()
  })

  it("opens on keyboard focus too", async () => {
    const container = await render(TooltipDemo)
    const trigger = container.querySelectorAll('[data-slot="tooltip-trigger"]')[0] as HTMLElement

    trigger.dispatchEvent(new window.FocusEvent("focus", { bubbles: true }))
    await wait(250)
    expect(document.querySelector('[data-slot="tooltip-content"]')).not.toBeNull()

    trigger.dispatchEvent(new window.FocusEvent("blur", { bubbles: true }))
    await flush()
    expect(document.querySelector('[data-slot="tooltip-content"]')).toBeNull()
  })
})
