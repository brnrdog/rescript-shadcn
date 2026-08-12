import baseMeta from "@/content/base/meta.json"
import ariaMeta from "@/content/aria/meta.json"
import xoteMeta from "@/content/xote/meta.json"
import MdxComponents from "@/src/MdxComponents.res.mjs";
import { getOgImagePath, getSelection, getSelectionName } from "@/src/OgStyles.js";
export const generateStaticParams = () =>
  [...new Set([...baseMeta.pages, ...ariaMeta.pages, ...xoteMeta.pages])].map(slug => ({ "slug": slug }))

// A component may not be documented for every lib; fall back to base so the
// route keeps resolving when a slug is missing from the selected lib.
const META_BY_LIB = { base: baseMeta, aria: ariaMeta, xote: xoteMeta }

function resolveLib(selection, slug) {
  return META_BY_LIB[selection.lib]?.pages.includes(slug) ? selection.lib : "base"
}

function importDocs(lib, slug) {
  switch (lib) {
    case "aria":
      return import(`@/content/aria/${slug}.mdx`)
    case "xote":
      return import(`@/content/xote/${slug}.mdx`)
    default:
      return import(`@/content/base/${slug}.mdx`)
  }
}
import { make as ComponentTitle } from "@/src/ComponentTitle.res.mjs";
export const dynamicParams = false;

const PRODUCTION_URL = "https://rescript-shadcn.miriad.studio";

function getMetadataBase() {
  return new URL(
    process.env.VERCEL_ENV === "preview" && process.env.VERCEL_URL
      ? `https://${process.env.VERCEL_URL}`
      : PRODUCTION_URL
  );
}

export const generateMetadata = async (props) => {
  const { slug } = await props.params
  const searchParams = await props.searchParams
  const selection = getSelection(searchParams)
  const lib = resolveLib(selection, slug)
  const { frontmatter: doc } = await importDocs(lib, slug)
  const title = `ReScript-Shadcn – ${doc.title}`
  const url = `/components/${slug}?style=${getSelectionName(searchParams)}`
  const images = [
    {
      url: getOgImagePath(slug, selection.style),
      width: 1200,
      height: 630,
    },
  ]

  return {
    title,
    description: doc.description,
    metadataBase: getMetadataBase(),
    openGraph: {
      title,
      description: doc.description,
      type: "article",
      url,
      images,
    },
    twitter: {
      card: "summary_large_image",
      title,
      description: doc.description,
      images,
      creator: "@miriad.studio",
    },
  }
}



export default async function Page({ params, searchParams }) {
  const { slug } = await params
  const selection = getSelection(await searchParams)
  const lib = resolveLib(selection, slug)
  const { default: ComponentDocs, frontmatter: doc } = await importDocs(lib, slug)
  return <>
    <ComponentTitle title={doc.title} />
    {doc.description && (
      <p className="text-[1.05rem] text-muted-foreground sm:text-base sm:text-balance md:max-w-[80%]">
        {doc.description}
      </p>
    )}
    <ComponentDocs components={MdxComponents} />
  </>
}
