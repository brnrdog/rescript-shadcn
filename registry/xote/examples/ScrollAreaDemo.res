let tags = Array.fromInitializer(~length=25, index => `v1.2.0-beta.${(25 - index)->Int.toString}`)

@xote.component
let make = () =>
  <ScrollArea className="h-72 w-48 rounded-md border">
    <div class="p-4">
      <h4 class="mb-4 text-sm leading-none font-medium"> {"Tags"} </h4>
      <View.For
        each={MaybeSignal.static(tags)}
        by={tag => tag}
        render={tag =>
          <div class="text-sm">
            {tag}
            <Separator className="my-2" />
          </div>}
      />
    </div>
  </ScrollArea>
