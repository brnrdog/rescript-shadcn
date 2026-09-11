@xote.component
let make = () =>
  <Empty>
    <Empty.Header>
      <Empty.Title> {"404 - Not Found"} </Empty.Title>
      <Empty.Description>
        {"The page you're looking for doesn't exist. Try searching for what you need below."}
      </Empty.Description>
    </Empty.Header>
    <Empty.Content>
      <InputGroup className="sm:w-3/4">
        <InputGroup.Input placeholder="Try searching for pages..." />
        <InputGroup.Addon>
          <Icons.Search />
        </InputGroup.Addon>
        <InputGroup.Addon align=InlineEnd>
          <Kbd> {"/"} </Kbd>
        </InputGroup.Addon>
      </InputGroup>
      <Empty.Description>
        {"Need help? "}
        <a href="#"> {"Contact support"} </a>
      </Empty.Description>
    </Empty.Content>
  </Empty>
