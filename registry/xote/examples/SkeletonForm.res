@xote.component
let make = () =>
  <div class="flex w-full max-w-xs flex-col gap-7">
    <div class="flex flex-col gap-3">
      <Skeleton className="h-4 w-20" />
      <Skeleton className="h-8 w-full" />
    </div>
    <div class="flex flex-col gap-3">
      <Skeleton className="h-4 w-24" />
      <Skeleton className="h-8 w-full" />
    </div>
    <Skeleton className="h-8 w-24" />
  </div>
