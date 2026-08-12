@xote.component
let make = () =>
  <div class="flex w-full max-w-xs items-center gap-3 rounded-lg border px-4 py-3">
    <Spinner />
    <span class="line-clamp-1 text-sm"> {"Processing payment..."} </span>
    <span class="ml-auto text-sm tabular-nums"> {"$100.00"} </span>
  </div>
