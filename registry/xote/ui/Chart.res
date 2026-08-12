@module("tailwind-merge")
external cn: (string, option<string>) => string = "twMerge"

/* Recharts is React-only, so this is a small SVG chart: enough for the bar and
   line shapes the docs show, with the theme's chart colours. */
type point = {
  label: string,
  value: float,
}

let maxValue = (data: array<point>) =>
  data->Array.reduce(0., (largest, point) => Math.max(largest, point.value))

module Container = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~id: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      id=?{id}
      class={cn(
        "cn-chart-container flex aspect-video justify-center text-xs [&_.chart-grid]:stroke-border/50",
        className,
      )}
      attrs=[View.attr("data-slot", "chart")]>
      {children}
    </div>
}

module Bar = {
  @xote.component
  let make = (
    ~data: array<point>,
    ~className: option<string>=?,
    ~color: string="var(--chart-1)",
    ~ariaLabel: string="Bar chart",
  ) => {
    let peak = maxValue(data)
    let count = data->Array.length
    let slot = count === 0 ? 0. : 100. /. count->Int.toFloat

    <Container className=?{className}>
      <svg
        viewBox="0 0 100 60"
        role="img"
        ariaLabel
        preserveAspectRatio="none"
        class="h-full w-full overflow-visible">
        <line x1="0" y1="50" x2="100" y2="50" class="chart-grid" strokeWidth="0.3" />
        <View.For
          each={MaybeSignal.static(data->Array.mapWithIndex((point, index) => (point, index)))}
          by={((point, index)) => `${point.label}-${index->Int.toString}`}
          render={((point, index)) => {
            let height = peak === 0. ? 0. : point.value /. peak *. 45.
            <rect
              x={(index->Int.toFloat *. slot +. slot *. 0.2)->Float.toString}
              y={(50. -. height)->Float.toString}
              width={(slot *. 0.6)->Float.toString}
              height={height->Float.toString}
              fill={color}
              rx="1"
            />
          }}
        />
      </svg>
    </Container>
  }
}

module Line = {
  @xote.component
  let make = (
    ~data: array<point>,
    ~className: option<string>=?,
    ~color: string="var(--chart-2)",
    ~ariaLabel: string="Line chart",
  ) => {
    let peak = maxValue(data)
    let count = data->Array.length
    let step = count <= 1 ? 0. : 100. /. (count - 1)->Int.toFloat

    let points =
      data
      ->Array.mapWithIndex((point, index) => {
        let y = peak === 0. ? 50. : 50. -. point.value /. peak *. 45.
        `${(index->Int.toFloat *. step)->Float.toString},${y->Float.toString}`
      })
      ->Array.join(" ")

    <Container className=?{className}>
      <svg
        viewBox="0 0 100 60"
        role="img"
        ariaLabel
        preserveAspectRatio="none"
        class="h-full w-full overflow-visible">
        <line x1="0" y1="50" x2="100" y2="50" class="chart-grid" strokeWidth="0.3" />
        <polyline points fill="none" stroke={color} strokeWidth="1" strokeLinejoin="round" />
      </svg>
    </Container>
  }
}

module Tooltip = {
  @xote.component
  let make = (
    ~className: option<string>=?,
    ~children: View.node=View.fragment([]),
  ) =>
    <div
      class={cn("cn-chart-tooltip", className)}
      attrs=[View.attr("data-slot", "chart-tooltip")]>
      {children}
    </div>
}
