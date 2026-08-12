@xote.component
let make = () =>
  <Resizable className="h-48 w-full max-w-md rounded-lg border" defaultRatio=40.>
    <Resizable.Panel className="flex items-center justify-center p-4 text-sm">
      {"Sidebar"}
    </Resizable.Panel>
    <Resizable.Handle withHandle=true />
    <Resizable.Panel grow=true className="flex items-center justify-center p-4 text-sm">
      {"Content"}
    </Resizable.Panel>
  </Resizable>
