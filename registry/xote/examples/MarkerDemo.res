@xote.component
let make = () =>
  <div class="flex w-full max-w-md flex-col gap-3">
    <Marker>
      <Marker.Icon>
        <Icons.Check />
      </Marker.Icon>
      <Marker.Content> {"Deployment finished"} </Marker.Content>
    </Marker>
    <Marker variant=Separator>
      <Marker.Content> {"Today"} </Marker.Content>
    </Marker>
    <Marker variant=Border>
      <Marker.Content> {"Draft saved"} </Marker.Content>
    </Marker>
  </div>
