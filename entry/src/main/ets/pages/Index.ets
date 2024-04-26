import display from '@ohos.display';
import url from '@ohos.url';
import Queue from '@ohos.util.Queue';
import { Card } from '../Card';
import { Constance } from '../Constant';

@Entry
@Component
struct Index {
  @State cards: Array<string> = []
  screenWidth: number = 0
  screenHeight: number = 0
  cardWidth: number = 300
  cardHeight: number = 700
  preCardOffsetX1: number = 0;
  preCardOffsetY1: number = 0;
  @State cardOffSetX1: number = 0;
  @State cardOffSetY1: number = 0;

  aboutToAppear() {
    this.screenWidth = px2vp(display.getDefaultDisplaySync().width);
    this.screenHeight = px2vp(display.getDefaultDisplaySync().height);
    console.log("---->>aboutToAppear width:" + this.screenWidth)
    console.log("---->>aboutToAppear height:" + this.screenHeight)
    this.cardWidth = this.screenWidth * 0.8
    this.cardHeight = this.cardHeight * 0.8
    this.preCardOffsetX1 = (this.screenWidth - this.cardWidth) / 2
    this.preCardOffsetY1 = (this.screenHeight - this.cardHeight) / 2


    console.log("---->>aboutToAppear preCardOffsetX1:" + this.preCardOffsetX1)
    console.log("---->>aboutToAppear preCardOffsetY1:" + this.preCardOffsetY1)
    this.cardOffSetX1 = this.preCardOffsetX1;
    this.cardOffSetY1 = this.preCardOffsetY1

    Constance.arrays.forEach((data: string) => {
      this.cards.push(data)
    })

    this.cards.reverse()
    console.log("---->>aboutToAppear cards:" + this.cards)


  }

  resetImg() {
    this.cardOffSetX1 = this.preCardOffsetX1;
    this.cardOffSetY1 = this.preCardOffsetY1;
  }

  handlePanEnd() {
    const distance = this.cardOffSetX1 - this.preCardOffsetX1
    console.log("---->>handlePanEnd abs:" + Math.abs(this.cardOffSetX1 - this.preCardOffsetX1))
    if (Math.abs(distance) > vp2px(10)) {

      animateTo({
        duration: 2000,
      }, () => {
        if (distance > 0) {
          this.cardOffSetX1 = 1000;
        } else {
          this.cardOffSetX1 = -1000;
        }
        this.cardOffSetY1 = 0;

      })
    } else {
      this.resetImg();
    }

  }

  getPositionFromIndex(index: number): Position {
    const length = this.cards.length - 1
    console.log("---->>getPositionFromIndex cardOffSetX1:" + this.cardOffSetX1)
    if (index == length) {

      return { x: this.cardOffSetX1, y: this.cardOffSetY1 }
      // return { x: 400, y: 500 }

    }

    if (index == length - 1) {
      return { x: this.preCardOffsetX1 + 10, y: this.preCardOffsetY1 - 10 }

    }

    return { x: this.preCardOffsetX1 + 20, y: this.preCardOffsetY1 - 20 }
  }

  getWidthFromIndex(index: number): number {
    const length = this.cards.length - 1
    if (index == length) {

      return this.cardWidth

    }

    if (index == length - 1) {
      return this.cardWidth - 20

    }

    return this.cardWidth - 40
  }

  getHeightFromIndex(index: number): number {
    const length = this.cards.length - 1
    if (index == length) {

      return this.cardHeight

    }

    if (index == length - 1) {
      return this.cardHeight - 20

    }

    return this.cardHeight - 40
  }

  getColorFromIndex(index: number): ResourceColor {
    const length = this.cards.length - 1
    if (index == length) {

      return Color.Red

    }

    if (index == length - 1) {
      return Color.Blue

    }

    return Color.Gray
  }

  queue: Queue<string> = new Queue()
  @State arr: string[] = []

  build() {

    Stack({ alignContent: Alignment.Top }) {

      ForEach(this.cards, (item: string, index: number) => {
        Text(index + ',' + item)
          .width(this.getWidthFromIndex(index))
          .height(this.getHeightFromIndex(index))
          .backgroundColor(this.getColorFromIndex(index))
          .borderRadius(24)
          .textAlign(TextAlign.Center)
          .position(this.getPositionFromIndex(index))
        // Image(item)
        //   .width(this.getWidthFromIndex(index))
        //   .height(this.getHeightFromIndex(index))
        //   .borderRadius(24)
        // .position(this.getPositionFromIndex(index))
        // .position({ x: 0, y: 0 })


      })

      Button('右滑').width(50).height(50).position({ x: 80 })
      Button('左滑').width(50).height(50).position({ x: 180 })


      //
      // Text('Third child, show in bottom')
      //   .width('80%')
      //   .height('100%')
      //   .backgroundColor(Color.Orange)
      //   .align(Alignment.Top)
      //   .borderRadius(24)
      //   .textAlign(TextAlign.Center)
      //
      // Text('Second child, show in middle')
      //   .width('85%')
      //   .height('95%')
      //   .backgroundColor(0xc1cbac)
      //   .align(Alignment.Top)
      //   .borderRadius(24)
      //   .textAlign(TextAlign.Center)
      // Text('First child, show in top')
      //   .width('90%')
      //   .height('90%')
      //   .borderRadius(24)
      //   .textAlign(TextAlign.Center)
      //   .position({ x: this.imgOffSetX, y: this.imgOffSetY })
      //   .backgroundColor(0xd2cab3)
      //   .align(Alignment.Top)
      //   .gesture(GestureGroup(GestureMode.Exclusive,
      //     PanGesture().onActionStart((event: GestureEvent) => {
      //       this.preOffsetX = this.imgOffSetX;
      //       this.preOffsetY = this.imgOffSetY;
      //       console.log("---->>PanGesture onActionStart:" + JSON.stringify(event))
      //     })
      //       .onActionUpdate((event: GestureEvent) => {
      //         // console.log("---->>PanGesture onActionUpdate:" + JSON.stringify(event))
      //         if (event) {
      //           this.imgOffSetX = this.preOffsetX + event.offsetX;
      //           this.imgOffSetY = this.preOffsetY + event.offsetY;
      //         }
      //       })
      //       .onActionEnd((event: GestureEvent) => {
      //         console.log("---->>PanGesture onActionEnd:" + JSON.stringify(event))
      //         this.handlePanEnd()
      //
      //       })
      //       .onActionCancel(() => {
      //         console.log("---->>PanGesture onActionCancel:")
      //       })
      //   ))


    }.width('100%').height('100%').padding({ bottom: 300 }).backgroundColor(Color.Pink)
  }
}

