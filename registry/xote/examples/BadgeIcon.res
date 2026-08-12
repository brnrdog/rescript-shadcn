@xote.component
let make = () =>
  <div class="flex flex-wrap gap-2">
    <Badge variant=Secondary>
      <Icons.BadgeCheck dataIcon="inline-start" />
      {"Verified"}
    </Badge>
    <Badge variant=Outline>
      {"Bookmark"}
      <Icons.Bookmark dataIcon="inline-end" />
    </Badge>
  </div>
