@xote.component
let make = () =>
  <div class="w-full overflow-hidden rounded-lg border">
    <Sidebar.Provider className="min-h-64">
      <Sidebar className="border-r">
        <Sidebar.Header>
          <Sidebar.Input placeholder="Search..." />
        </Sidebar.Header>
        <Sidebar.Content>
          <Sidebar.Group>
            <Sidebar.GroupLabel> {"Platform"} </Sidebar.GroupLabel>
            <Sidebar.GroupContent>
              <Sidebar.Menu>
                <Sidebar.MenuItem>
                  <Sidebar.MenuButton href="#" active=true>
                    <Icons.Check />
                    {"Playground"}
                  </Sidebar.MenuButton>
                </Sidebar.MenuItem>
                <Sidebar.MenuItem>
                  <Sidebar.MenuButton href="#">
                    <Icons.Search />
                    {"Explore"}
                    <Sidebar.MenuBadge> {"12"} </Sidebar.MenuBadge>
                  </Sidebar.MenuButton>
                </Sidebar.MenuItem>
              </Sidebar.Menu>
            </Sidebar.GroupContent>
          </Sidebar.Group>
        </Sidebar.Content>
        <Sidebar.Footer>
          <span class="text-muted-foreground px-2 text-xs"> {"v1.0.0"} </span>
        </Sidebar.Footer>
      </Sidebar>
      <Sidebar.Inset>
        <div class="flex items-center gap-2 border-b p-2">
          <Sidebar.Trigger />
          <span class="text-sm font-medium"> {"Dashboard"} </span>
        </div>
        <div class="p-4 text-sm text-muted-foreground"> {"Toggle the sidebar from the header."} </div>
      </Sidebar.Inset>
    </Sidebar.Provider>
  </div>
