@xote.component
let make = () =>
  <Drawer>
    <Drawer.Trigger className={Button.buttonVariants(~variant=Outline)}>
      {"Open Drawer"}
    </Drawer.Trigger>
    <Drawer.Content className="p-4">
      <Drawer.Header>
        <Drawer.Title> {"Move goal"} </Drawer.Title>
        <Drawer.Description> {"Set your daily activity goal."} </Drawer.Description>
      </Drawer.Header>
      <Drawer.Footer>
        <Button> {"Submit"} </Button>
        <Drawer.Close className={Button.buttonVariants(~variant=Outline)}> {"Cancel"} </Drawer.Close>
      </Drawer.Footer>
    </Drawer.Content>
  </Drawer>
