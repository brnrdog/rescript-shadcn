@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-5">
    <Marker role="status">
      <Marker.Icon>
        <Spinner />
      </Marker.Icon>
      <Marker.Content> {"Compacting conversation"} </Marker.Content>
    </Marker>
    <Marker role="status">
      <Marker.Content className="shimmer"> {"Thinking..."} </Marker.Content>
    </Marker>
    <Marker variant=Separator role="status">
      <Marker.Icon>
        <Spinner />
      </Marker.Icon>
      <Marker.Content> {"Loading earlier messages"} </Marker.Content>
    </Marker>
  </div>
