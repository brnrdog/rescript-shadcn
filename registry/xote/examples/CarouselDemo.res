@xote.component
let make = () =>
  <Carousel className="w-full max-w-xs">
    <Carousel.Content>
      <View.For
        each={MaybeSignal.static([1, 2, 3, 4, 5])}
        by={index => index->Int.toString}
        render={index =>
          <Carousel.Item className="p-1">
            <Card>
              <Card.Content className="flex aspect-square items-center justify-center p-6">
                <span class="text-4xl font-semibold"> {index->Int.toString} </span>
              </Card.Content>
            </Card>
          </Carousel.Item>}
      />
    </Carousel.Content>
    <Carousel.Previous />
    <Carousel.Next />
  </Carousel>
