import display from '@ohos.display';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  preOffsetX: number = 0;
  preOffsetY: number = 0;
  @State imgOffSetX: number = 0;
  @State imgOffSetY: number = 0;

  resetImg() {
    this.imgOffSetY = this.imgOffSetY;
    this.imgOffSetX = this.preOffsetX;
  }

  handlePanEnd() {
    console.log("---->>handlePanEnd 10:" + vp2px(10))
    console.log("---->>handlePanEnd imgOffSetX:" + this.imgOffSetX)
    console.log("---->>handlePanEnd preOffsetX:" + this.preOffsetX)
    console.log("---->>handlePanEnd 距离:" + (this.imgOffSetX - this.preOffsetX))
    const distance = this.imgOffSetX - this.preOffsetX
    console.log("---->>handlePanEnd abs:" + Math.abs(this.imgOffSetX - this.preOffsetX))
    if (Math.abs(distance) > vp2px(10)) {

      animateTo({
        duration: 2000,
      }, () => {
        if (distance > 0) {
          this.imgOffSetX = 1000;
        } else {
          this.imgOffSetX = -1000;
        }
        this.imgOffSetY = 0;

      })
    } else {
      this.resetImg();
    }

  }

  aboutToAppear() {
    const width = display.getDefaultDisplaySync().width;
    const height = display.getDefaultDisplaySync().height;
    console.log("---->>aboutToAppear width:" + width)
    console.log("---->>aboutToAppear height:" + height)
    this.imgOffSetX = px2vp(width * 0.05)
    this.imgOffSetY = px2vp(height * 0.1)

    console.log("---->>aboutToAppear imgOffSetX:" + this.imgOffSetX)
    console.log("---->>aboutToAppear imgOffSetY:" + this.imgOffSetY)


  }

  build() {


    Stack({ alignContent: Alignment.Bottom }) {

      Text('Third child, show in bottom')
        .width('80%')
        .height('100%')
        .backgroundColor(Color.Orange)
        .align(Alignment.Top)
        .borderRadius(24)
        .textAlign(TextAlign.Center)

      Text('Second child, show in middle')
        .width('85%')
        .height('95%')
        .backgroundColor(0xc1cbac)
        .align(Alignment.Top)
        .borderRadius(24)
        .textAlign(TextAlign.Center)
      Text('First child, show in top')
        .width('90%')
        .height('90%')
        .borderRadius(24)
        .textAlign(TextAlign.Center)
        .position({ x: this.imgOffSetX, y: this.imgOffSetY })
        .backgroundColor(0xd2cab3)
        .align(Alignment.Top)
        .gesture(GestureGroup(GestureMode.Exclusive,
          PanGesture().onActionStart((event: GestureEvent) => {
            this.preOffsetX = this.imgOffSetX;
            this.preOffsetY = this.imgOffSetY;
            console.log("---->>PanGesture onActionStart:" + JSON.stringify(event))
          })
            .onActionUpdate((event: GestureEvent) => {
              // console.log("---->>PanGesture onActionUpdate:" + JSON.stringify(event))
              if (event) {
                this.imgOffSetX = this.preOffsetX + event.offsetX;
                this.imgOffSetY = this.preOffsetY + event.offsetY;
              }
            })
            .onActionEnd((event: GestureEvent) => {
              console.log("---->>PanGesture onActionEnd:" + JSON.stringify(event))
              this.handlePanEnd()

            })
            .onActionCancel(() => {
              console.log("---->>PanGesture onActionCancel:")
            })
        ))


    }.width('100%').height('100%').margin({ top: 5 }).padding({ bottom: 100, top: 100 })
  }
}