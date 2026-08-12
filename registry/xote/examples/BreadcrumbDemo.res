@xote.component
let make = () =>
  <Breadcrumb>
    <Breadcrumb.List>
      <Breadcrumb.Item>
        <Breadcrumb.Link href="#"> {"Home"} </Breadcrumb.Link>
      </Breadcrumb.Item>
      <Breadcrumb.Separator>
        <Icons.ChevronRight className="cn-rtl-flip" />
      </Breadcrumb.Separator>
      <Breadcrumb.Item>
        <Breadcrumb.Link href="#"> {"Components"} </Breadcrumb.Link>
      </Breadcrumb.Item>
      <Breadcrumb.Separator>
        <Icons.ChevronRight className="cn-rtl-flip" />
      </Breadcrumb.Separator>
      <Breadcrumb.Item>
        <Breadcrumb.Page> {"Breadcrumb"} </Breadcrumb.Page>
      </Breadcrumb.Item>
    </Breadcrumb.List>
  </Breadcrumb>
