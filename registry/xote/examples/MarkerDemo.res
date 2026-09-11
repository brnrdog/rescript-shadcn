@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-5">
    <Marker>
      <Marker.Content> {"A default marker"} </Marker.Content>
    </Marker>
    <Marker>
      <Marker.Icon>
        <Icons.FileText />
      </Marker.Icon>
      <Marker.Content> {"Opened implementation notes"} </Marker.Content>
    </Marker>
    <Marker role="status">
      <Marker.Icon>
        <Spinner />
      </Marker.Icon>
      <Marker.Content> {"Reading 4 files"} </Marker.Content>
    </Marker>
  </div>
