@xote.component
let make = () =>
  <div class="flex flex-wrap items-center gap-2">
    <Button
      variant=Outline
      onClick={_ =>
        Toast.add(
          ~title="Event created",
          ~description="Sunday, December 03, 2023 at 9:00 AM",
        )->ignore}>
      {"Show toast"}
    </Button>
    <Button
      variant=Outline
      onClick={_ =>
        Toast.add(~title="Something went wrong", ~variant=Destructive)->ignore}>
      {"Show destructive"}
    </Button>
    <Toast.Toaster />
  </div>
