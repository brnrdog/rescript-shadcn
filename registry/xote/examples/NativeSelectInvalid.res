@xote.component
let make = () =>
  <NativeSelect invalid={true}>
    <NativeSelect.Option value=""> {"Error state"} </NativeSelect.Option>
    <NativeSelect.Option value="apple"> {"Apple"} </NativeSelect.Option>
    <NativeSelect.Option value="banana"> {"Banana"} </NativeSelect.Option>
    <NativeSelect.Option value="blueberry"> {"Blueberry"} </NativeSelect.Option>
  </NativeSelect>
