@xote.component
let make = () =>
  <Pagination>
    <Pagination.Content>
      <Pagination.Item>
        <Pagination.Previous href="#" />
      </Pagination.Item>
      <Pagination.Item>
        <Pagination.Link href="#"> {"1"} </Pagination.Link>
      </Pagination.Item>
      <Pagination.Item>
        <Pagination.Link href="#" isActive=true> {"2"} </Pagination.Link>
      </Pagination.Item>
      <Pagination.Item>
        <Pagination.Link href="#"> {"3"} </Pagination.Link>
      </Pagination.Item>
      <Pagination.Item>
        <Pagination.Ellipsis />
      </Pagination.Item>
      <Pagination.Item>
        <Pagination.Next href="#" />
      </Pagination.Item>
    </Pagination.Content>
  </Pagination>
