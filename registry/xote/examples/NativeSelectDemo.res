@xote.component
let make = () =>
  <NativeSelect>
    <NativeSelect.Option value=""> {"Select status"} </NativeSelect.Option>
    <NativeSelect.Option value="todo"> {"Todo"} </NativeSelect.Option>
    <NativeSelect.Option value="in-progress"> {"In Progress"} </NativeSelect.Option>
    <NativeSelect.Option value="done"> {"Done"} </NativeSelect.Option>
    <NativeSelect.Option value="cancelled"> {"Cancelled"} </NativeSelect.Option>
  </NativeSelect>
