import display from '@ohos.display';
import url from '@ohos.url';
import Queue from '@ohos.util.Queue';
import hilog from '@ohos.hilog';
import { Card } from '../Card';
import { Constance } from '../Constant';
import curves from '@ohos.curves';

@Entry
@Component
struct Index {
  @State cards: Array<string> = []
  screenWidth: number = 0
  screenHeight: number = 0
  cardWidth: number = 300
  cardHeight: number = 700
  preCardOffsetX1 : number = 0
  preCardOffsetY1 : number = 0
  initCardOffsetX1: number = 0;
  initCardOffsetY1: number = 0;
  @State cardOffSetX1: number = 0;
  @State cardOffSetY1: number = 0;

  aboutToAppear() {
    this.screenWidth = px2vp(display.getDefaultDisplaySync().width);
    this.screenHeight = px2vp(display.getDefaultDisplaySync().height);
    console.log("---->>aboutToAppear width:" + this.screenWidth)
    console.log("---->>aboutToAppear height:" + this.screenHeight)
    this.cardWidth = this.screenWidth * 0.8
    this.cardHeight = this.cardHeight * 0.8
    this.initCardOffsetX1 = (this.screenWidth - this.cardWidth) / 2
    this.initCardOffsetY1 = (this.screenHeight - this.cardHeight) / 2


    console.log("---->>aboutToAppear initCardOffsetX1:" + this.initCardOffsetX1)
    console.log("---->>aboutToAppear initCardOffsetY1:" + this.initCardOffsetY1)
    this.cardOffSetX1 = this.initCardOffsetX1;
    this.cardOffSetY1 = this.initCardOffsetY1

    this.getData()

    // Constance.arrays.forEach((data: string) => {
    //   this.cards.push(data)
    // })

    // this.cards.reverse()
    console.log("---->>aboutToAppear cards:" + this.cards)


  }

  pageNum = 0
  getData(){
    this.cards.reverse()
    Constance.arrays.forEach((data: string) => {
       const item  = Number.parseInt(data) + this.pageNum * 10
      this.cards.push(item +"")

    })
    this.cards.reverse()
    this.pageNum++

  }

  resetImg() {
    this.cardOffSetX1 = this.initCardOffsetX1;
    this.cardOffSetY1 = this.initCardOffsetY1;
  }

  onLike(){
    animateTo({
      duration: 1000,
      onFinish:()=>{
        this.getData()
      }
    }, () => {
      this.cards.pop()
      this.cardOffSetX1 = this.initCardOffsetX1;
      this.cardOffSetY1 = this.initCardOffsetY1;
    })

  }

  onDislike(){
    animateTo({
      duration: 1000,
      onFinish:()=>{
        this.getData()
      }
    }, () => {
      this.cards.pop()
      this.cardOffSetX1 = this.initCardOffsetX1;
      this.cardOffSetY1 = this.initCardOffsetY1;
    })
  }

  handlePanEnd() {
    const distance = this.cardOffSetX1 - this.initCardOffsetX1
    hilog.error(0x0000, 'testTag', "---->>handlePanEnd abs:" + Math.abs(this.cardOffSetX1 - this.initCardOffsetX1));
    if (Math.abs(distance) > vp2px(10)) {

      animateTo({
        duration: 1000,
        onFinish:()=>{
          this.getData()
        }
      }, () => {
        if (distance > 0) {
          this.cards.pop()
          this.cardOffSetX1 = this.initCardOffsetX1;
          this.cardOffSetY1 = this.initCardOffsetY1;
        } else {
          this.cardOffSetX1 = this.initCardOffsetX1;
          this.cardOffSetY1 = this.initCardOffsetY1;
          this.cards.pop()
        }
      })
    } else {
      // https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-spring-animation-0000001450915478-V2
      // 弹簧曲线动画
      animateTo({curve: curves.springMotion()},() =>{
        this.resetImg();
      })
      // animateTo({duration:300},() =>{
      //   this.resetImg();
      // })

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
      return { x: this.initCardOffsetX1 + 10, y: this.initCardOffsetY1 - 10 }

    }

    return { x: this.initCardOffsetX1 + 20, y: this.initCardOffsetY1 - 20 }
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

  getUrlFromIndex(index: number) {
    if (index % 4 == 0) {

      return "https://s1.qianshouapp.cn/v2/group-images/eyJpZCI6IjRLN09GSkYzUU1YRlVXWEhOV0lESDJNSVZCSzdCQjA5IiwidyI6MTA3OSwiaCI6MTQ0NiwiZCI6MCwibXQiOiJpbWFnZS9qcGVnIiwiZGgiOjUxOTkwODE5Mjg1MDQyMjY5MTh9.jpg?format=max_960xX_p3"

    }

    if (index % 4 == 1) {
      return "http://cloud.staging.p1.cn/v2/group-images/eyJpZCI6IlZDSTZIVkJUQVJJUVdFQjVLTFNHN0k2QUVTSUZJNiIsInciOjEwODAsImgiOjE0NDAsImQiOjAsIm10IjoiaW1hZ2UvanBlZyIsImRoIjoxNjQ4OTEzMjcwMjIxMzc2NTQ5N30"

    }
    if (index % 4 == 2) {
      return "http://cloud.staging.p1.cn/v2/group-images/eyJpZCI6IjNWU05HSDdUM1NaQVdBVjdRNjZVVkwyTlc2SEk2RyIsInciOjgyOCwiaCI6MTc5MiwiZCI6MCwibXQiOiJpbWFnZS9qcGVnIiwiZGgiOjU1MDcxNTMyMjE3OTM5NDU4NjB9"

    }

    return "http://cloud.staging.p1.cn/v2/group-images/eyJpZCI6IkVVVUdNUk9YNUdaS1dBVklSSjNNQU83SEZZRk00QyIsInciOjEwODAsImgiOjE0NDAsImQiOjAsIm10IjoiaW1hZ2UvanBlZyIsImRoIjo2Mzc0MjU0MzE3OTA2MjM3OTc4fQ"

  }




  build() {

    Stack({ alignContent: Alignment.Top }) {

      ForEach(this.cards, (item: string, index: number) => {
        Text('index:'+index + ',内容：' + item)
        // .textAlign(TextAlign.Center)
        .backgroundColor(this.getColorFromIndex(index))
        // Image(this.getUrlFromIndex(index))
          .width(this.getWidthFromIndex(index))
          .height(this.getHeightFromIndex(index))
          .borderRadius(24)
          .position(this.getPositionFromIndex(index))
          // .transition({ type: TransitionType.Delete, translate: { x: 2000, y: 0 } })
          .gesture(GestureGroup(GestureMode.Exclusive,
            PanGesture().onActionStart((event: GestureEvent) => {
              this.preCardOffsetX1 = this.cardOffSetX1;
              this.preCardOffsetY1 = this.cardOffSetY1;
              console.log("---->>PanGesture onActionStart:" + JSON.stringify(event))
            })
              .onActionUpdate((event: GestureEvent) => {
                // console.log("---->>PanGesture onActionUpdate:" + JSON.stringify(event))
                if (event) {
                  this.cardOffSetX1 = this.preCardOffsetX1 + event.offsetX;
                  this.cardOffSetY1 = this.preCardOffsetY1 + event.offsetY;
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
        // Image(item)
        //   .width(this.getWidthFromIndex(index))
        //   .height(this.getHeightFromIndex(index))
        //   .borderRadius(24)
        // .position(this.getPositionFromIndex(index))
        // .position({ x: 0, y: 0 })


      })

      Button('右滑').width(50).height(50).position({ x: 80 }).onClick((event)=>{
        this.onLike()
      })
      Button('左滑').width(50).height(50).position({ x: 180 }).onClick((event)=>{
        this.onDislike()
      })


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

