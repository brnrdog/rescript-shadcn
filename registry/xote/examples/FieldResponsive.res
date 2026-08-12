@xote.component
let make = () =>
  <div class="w-full max-w-lg">
    <form>
      <Field.Set>
        <Field.Legend> {"Profile"} </Field.Legend>
        <Field.Description> {"Fill in your profile information."} </Field.Description>
        <Field.Group>
          <Field orientation=Responsive>
            <Field.Content>
              <Field.Label for_="name"> {"Name"} </Field.Label>
              <Field.Description>
                {"Provide your full name for identification"}
              </Field.Description>
            </Field.Content>
            <Input id="name" placeholder="Evil Rabbit" required={true} />
          </Field>
          <Field orientation=Responsive>
            <Button type_="submit"> {"Submit"} </Button>
            <Button type_="button" variant=Outline> {"Cancel"} </Button>
          </Field>
        </Field.Group>
      </Field.Set>
    </form>
  </div>
