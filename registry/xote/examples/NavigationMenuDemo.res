@xote.component
let make = () =>
  <NavigationMenu ariaLabel="Main">
    <NavigationMenu.List className="gap-2">
      <NavigationMenu.Item>
        <NavigationMenu.Trigger className={Button.buttonVariants(~variant=Ghost)}>
          {"Getting started"}
        </NavigationMenu.Trigger>
        <NavigationMenu.Content className="w-64">
          <NavigationMenu.Link href="#">
            <div class="text-sm font-medium"> {"Introduction"} </div>
            <p class="text-muted-foreground text-sm"> {"Re-usable components built with xote."} </p>
          </NavigationMenu.Link>
          <NavigationMenu.Link href="#">
            <div class="text-sm font-medium"> {"Installation"} </div>
            <p class="text-muted-foreground text-sm"> {"How to install and configure."} </p>
          </NavigationMenu.Link>
        </NavigationMenu.Content>
      </NavigationMenu.Item>
      <NavigationMenu.Item>
        <NavigationMenu.Trigger className={Button.buttonVariants(~variant=Ghost)}>
          {"Components"}
        </NavigationMenu.Trigger>
        <NavigationMenu.Content className="w-64">
          <NavigationMenu.Link href="#" active=true> {"Accordion"} </NavigationMenu.Link>
          <NavigationMenu.Link href="#"> {"Dialog"} </NavigationMenu.Link>
        </NavigationMenu.Content>
      </NavigationMenu.Item>
    </NavigationMenu.List>
  </NavigationMenu>
