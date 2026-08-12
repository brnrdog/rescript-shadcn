@xote.component
let make = () =>
  <div class="flex items-center gap-2">
    <Button
      variant=Outline
      onClick={_ =>
        Sonner.toast(~title="Deployed", ~description="Your changes are live.")->ignore}>
      {"Show notification"}
    </Button>
    <Sonner.Toaster />
  </div>
