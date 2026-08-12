@xote.component
let make = () =>
  <div class="flex w-full max-w-xs flex-col gap-4 [--radius:1rem]">
    <Item variant=Item.Variant.Muted>
      <Item.Media>
        <Spinner />
      </Item.Media>
      <Item.Content>
        <Item.Title className="line-clamp-1"> {"Processing payment..."} </Item.Title>
      </Item.Content>
      <Item.Content className="flex-none justify-end">
        <span class="text-sm tabular-nums"> {"$100.00"} </span>
      </Item.Content>
    </Item>
  </div>
