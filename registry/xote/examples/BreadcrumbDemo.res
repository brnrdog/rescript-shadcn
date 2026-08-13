@xote.component
let make = () =>
  <Breadcrumb>
    <Breadcrumb.List>
      <Breadcrumb.Item>
        <Breadcrumb.Link href="#"> {"Home"} </Breadcrumb.Link>
      </Breadcrumb.Item>
      <Breadcrumb.Separator />
      <Breadcrumb.Item>
        <DropdownMenu>
          <DropdownMenu.Trigger className={Button.buttonVariants(~variant=Ghost, ~size=IconSm)}>
            <Breadcrumb.Ellipsis />
            <span class="sr-only"> {"Toggle menu"} </span>
          </DropdownMenu.Trigger>
          <DropdownMenu.Content align=Start>
            <DropdownMenu.Group>
              <DropdownMenu.Item> {"Documentation"} </DropdownMenu.Item>
              <DropdownMenu.Item> {"Themes"} </DropdownMenu.Item>
              <DropdownMenu.Item> {"GitHub"} </DropdownMenu.Item>
            </DropdownMenu.Group>
          </DropdownMenu.Content>
        </DropdownMenu>
      </Breadcrumb.Item>
      <Breadcrumb.Separator />
      <Breadcrumb.Item>
        <Breadcrumb.Link href="#"> {"Components"} </Breadcrumb.Link>
      </Breadcrumb.Item>
      <Breadcrumb.Separator />
      <Breadcrumb.Item>
        <Breadcrumb.Page> {"Breadcrumb"} </Breadcrumb.Page>
      </Breadcrumb.Item>
    </Breadcrumb.List>
  </Breadcrumb>
