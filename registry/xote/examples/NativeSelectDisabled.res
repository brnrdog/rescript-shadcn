@xote.component
let make = () =>
  <NativeSelect disabled={true}>
    <NativeSelect.Option value=""> {"Disabled"} </NativeSelect.Option>
    <NativeSelect.Option value="apple"> {"Apple"} </NativeSelect.Option>
    <NativeSelect.Option value="banana"> {"Banana"} </NativeSelect.Option>
    <NativeSelect.Option value="blueberry"> {"Blueberry"} </NativeSelect.Option>
  </NativeSelect>
