@xote.component
let make = () =>
  <Empty className="border border-dashed rounded-lg p-8">
    <Empty.Header>
      <Empty.Media variant=Icon>
        <Icons.Search />
      </Empty.Media>
      <Empty.Title> {"No results found"} </Empty.Title>
      <Empty.Description>
        {"Try adjusting your search or filters to find what you are looking for."}
      </Empty.Description>
    </Empty.Header>
    <Empty.Content>
      <Button variant=Outline> {"Clear filters"} </Button>
    </Empty.Content>
  </Empty>
