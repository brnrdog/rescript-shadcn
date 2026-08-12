@xote.component
let make = () =>
  <AlertDialog>
    <AlertDialog.Trigger className={Button.buttonVariants(~variant=Outline)}>
      {"Show Dialog"}
    </AlertDialog.Trigger>
    <AlertDialog.Content>
      <AlertDialog.Header>
        <AlertDialog.Title> {"Are you absolutely sure?"} </AlertDialog.Title>
        <AlertDialog.Description>
          {"This action cannot be undone. This will permanently delete your account and remove your data from our servers."}
        </AlertDialog.Description>
      </AlertDialog.Header>
      <AlertDialog.Footer>
        <AlertDialog.Cancel> {"Cancel"} </AlertDialog.Cancel>
        <AlertDialog.Action> {"Continue"} </AlertDialog.Action>
      </AlertDialog.Footer>
    </AlertDialog.Content>
  </AlertDialog>
