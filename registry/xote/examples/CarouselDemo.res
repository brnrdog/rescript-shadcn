@xote.component
let make = () =>
  <Carousel className="w-full max-w-[12rem] sm:max-w-xs">
    <Carousel.Content>
      <View.For
        each={MaybeSignal.static([1, 2, 3, 4, 5])}
        by={index => index->Int.toString}
        render={index =>
          <Carousel.Item>
            <div class="p-1">
              <Card>
                <Card.Content className="flex aspect-square items-center justify-center p-6">
                  <span class="text-4xl font-semibold"> {index->Int.toString} </span>
                </Card.Content>
              </Card>
            </div>
          </Carousel.Item>}
      />
    </Carousel.Content>
    <Carousel.Previous />
    <Carousel.Next />
  </Carousel>
