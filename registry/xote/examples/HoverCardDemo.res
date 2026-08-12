@xote.component
let make = () =>
  <HoverCard>
    <HoverCard.Trigger className={Button.buttonVariants(~variant=Link)}> {"@shadcn"} </HoverCard.Trigger>
    <HoverCard.Content className="w-80">
      <div class="flex justify-between gap-4">
        <Avatar>
          <Avatar.Image src="https://github.com/shadcn.png" alt="@shadcn" />
          <Avatar.Fallback> {"CN"} </Avatar.Fallback>
        </Avatar>
        <div class="flex flex-col gap-1">
          <h4 class="text-sm font-semibold"> {"@shadcn"} </h4>
          <p class="text-sm"> {"The creator of shadcn/ui. Building things for the web."} </p>
          <span class="text-muted-foreground text-xs"> {"Joined December 2021"} </span>
        </div>
      </div>
    </HoverCard.Content>
  </HoverCard>
