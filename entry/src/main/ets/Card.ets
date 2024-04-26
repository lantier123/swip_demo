export interface CardData {
  name: string;
}

@Component
export struct Card{
   cardData : CardData


  aboutToAppear(){
    console.log(this.cardData.name)
  }


  build(){

  }

}