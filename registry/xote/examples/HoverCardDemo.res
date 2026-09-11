@xote.component
let make = () =>
  <HoverCard delay=10 closeDelay=100>
    <HoverCard.Trigger className={Button.buttonVariants(~variant=Link)}>
      {"Hover Here"}
    </HoverCard.Trigger>
    <HoverCard.Content className="flex w-64 flex-col gap-0.5">
      <div class="font-semibold"> {"@nextjs"} </div>
      <div> {"The React Framework – created and maintained by @vercel."} </div>
      <div class="text-muted-foreground mt-1 text-xs">
        {"Joined December 2021"}
      </div>
    </HoverCard.Content>
  </HoverCard>
