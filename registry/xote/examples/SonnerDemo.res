@xote.component
let make = () =>
  <div class="flex items-center gap-2">
    <Button
      variant=Outline
      onClick={_ =>
        Sonner.toast(
          "Event has been created",
          ~options={
            description: "Sunday, December 03, 2023 at 9:00 AM",
            action: {label: "Undo", onClick: () => Console.log("Undo")},
          },
        )->ignore}>
      {"Show Toast"}
    </Button>
    <Sonner.Toaster />
  </div>
