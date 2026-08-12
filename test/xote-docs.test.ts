import { existsSync, readFileSync, readdirSync } from "node:fs"
import { join } from "node:path"

import { describe, expect, it } from "vitest"

const root = join(__dirname, "..")
const contentDir = join(root, "content", "xote")
const examplesDir = join(root, "registry", "xote", "examples")
const uiDir = join(root, "registry", "xote", "ui")

const pages: string[] = JSON.parse(
  readFileSync(join(contentDir, "meta.json"), "utf8")
).pages

const basePages: string[] = JSON.parse(
  readFileSync(join(root, "content", "base", "meta.json"), "utf8")
).pages

const read = (page: string) => readFileSync(join(contentDir, `${page}.mdx`), "utf8")
const matchAll = (source: string, pattern: RegExp) =>
  [...source.matchAll(pattern)].map((match) => match[1])

describe("xote documentation", () => {
  it("documents the same components as the base registry", () => {
    expect([...pages].sort()).toEqual([...basePages].sort())
  })

  it("lists every page it ships and ships every page it lists", () => {
    const files = readdirSync(contentDir)
      .filter((file) => file.endsWith(".mdx"))
      .map((file) => file.slice(0, -4))
    expect([...pages].sort()).toEqual(files.sort())
  })

  it.each(pages)("%s renders previews that exist", (page) => {
    const previews = matchAll(read(page), /<ComponentPreview\s+name="([^"]+)"/g)
    const missing = previews.filter(
      (name) => !existsSync(join(examplesDir, `${name}.res`))
    )
    expect(missing).toEqual([])
  })

  it.each(pages)("%s links component sources that exist", (page) => {
    const sources = matchAll(read(page), /<ComponentSource\s+name="([^"]+)"/g)
    const missing = sources.filter((name) => !existsSync(join(uiDir, `${name}.res`)))
    expect(missing).toEqual([])
  })

  it.each(pages)("%s installs the dependencies its component actually needs", (page) => {
    const registry = JSON.parse(readFileSync(join(root, "registry.xote.json"), "utf8"))
    const item = registry.items.find(
      (entry: { name: string; type: string }) =>
        entry.name === page && entry.type === "registry:ui"
    )
    if (!item) return

    const install = read(page).match(/npm install ([^\n]+)/)
    if (!install) return

    const documented = new Set(install[1].split(/\s+/))
    for (const dependency of item.dependencies ?? []) {
      expect(documented.has(dependency)).toBe(true)
    }
  })

  it("does not describe the React libraries it replaced as if they were used", () => {
    // Calendar's page explains why it is hand-written, so it may name the library.
    const offenders = pages
      .filter((page) => page !== "Calendar")
      .filter((page) => /react-day-picker|embla|cmdk|vaul|@tanstack\/react-table|lucide-react|@base-ui|react-aria/i.test(read(page)))
    expect(offenders).toEqual([])
  })
})
