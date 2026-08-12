@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-6">
    <Marker>
      <Marker.Content> {"Default marker"} </Marker.Content>
    </Marker>
    <Marker variant=Border>
      <Marker.Icon>
        <Icons.Archive />
      </Marker.Icon>
      <Marker.Content> {"Switched to release-candidate"} </Marker.Content>
    </Marker>
    <Marker variant=Separator>
      <Marker.Content> {"Today"} </Marker.Content>
    </Marker>
  </div>
