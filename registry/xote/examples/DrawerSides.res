let sides: array<Drawer.Direction.t> = [Top, Right, Bottom, Left]

let paragraph = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

@xote.component
let make = () =>
  <div class="flex flex-wrap gap-2">
    <View.For
      each={MaybeSignal.static(sides)}
      by={side => (side :> string)}
      render={side =>
        <Drawer>
          <Drawer.Trigger
            className={Button.buttonVariants(~variant=Outline, ~className="capitalize")}>
            {(side :> string)}
          </Drawer.Trigger>
          <Drawer.Content
            direction=side
            className="data-[vaul-drawer-direction=bottom]:max-h-[50vh] data-[vaul-drawer-direction=top]:max-h-[50vh]">
            <Drawer.Header>
              <Drawer.Title> {"Move Goal"} </Drawer.Title>
              <Drawer.Description> {"Set your daily activity goal."} </Drawer.Description>
            </Drawer.Header>
            <div class="no-scrollbar overflow-y-auto px-4">
              <View.For
                each={MaybeSignal.static([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])}
                by={index => index->Int.toString}
                render={_ => <p class="mb-4 leading-normal"> {paragraph} </p>}
              />
            </div>
            <Drawer.Footer>
              <Button> {"Submit"} </Button>
              <Drawer.Close className={Button.buttonVariants(~variant=Outline)}>
                {"Cancel"}
              </Drawer.Close>
            </Drawer.Footer>
          </Drawer.Content>
        </Drawer>}
    />
  </div>
