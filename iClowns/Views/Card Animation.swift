//
//  Card Animation.swift
//  WonderSeek
//
//  Created by Giuseppe Olivari on 04/06/24.
//


import SwiftUI

/// A struct that represents the front of a card
struct CardFront : View {
    /// The width of the card
    let width : CGFloat
    /// The height of the card
    let height : CGFloat
    /// The degree of rotation for the card
    @Binding var degree : Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 2, x: 0, y: 0)
            /*
            Image(systemName: "suit.club.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
             */
            
            Text("FRONTE")
                .bold()
                .font(.largeTitle)

        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

//RETRO DELLA CARTA
struct CardBack : View {
    /// The width of the card
    let width : CGFloat
    /// The height of the card
    let height : CGFloat
    /// The degree of rotation for the card
    @Binding var degree : Double

    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue.opacity(0.7), lineWidth: 3)
                .frame(width: width, height: height)

            RoundedRectangle(cornerRadius: 20)
                .fill(.blue.opacity(0.2))
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 2, x: 0, y: 0)

            RoundedRectangle(cornerRadius: 20)
                .fill(.blue.opacity(0.7))
                .padding()
                .frame(width: width, height: height)

            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue.opacity(0.7), lineWidth: 3)
                .padding()
                .frame(width: width, height: height)

            Text("RETRO")
                .bold()
                .font(.largeTitle)
            
            Image(systemName: "seal")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundColor(.blue.opacity(0.7))

        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))

    }
}

/// A struct that represents the main view of the card flip animation
struct Card_Animation: View {
    /// The degree of rotation for the back of the card
    @State var backDegree = 0.0
    /// The degree of rotation for the front of the card
    @State var frontDegree = -90.0
/// A boolean that keeps track of whether the card is flipped or not
@State var isFlipped = false
    /// The width of the card
let width : CGFloat = 200
/// The height of the card
let height : CGFloat = 250
/// The duration and delay of the flip animation
let durationAndDelay : CGFloat = 0.3

/// A function that flips the card by updating the degree of rotation for the front and back of the card
func flipCard () {
    isFlipped = !isFlipped
    if isFlipped {
        withAnimation(.linear(duration: durationAndDelay)) {
            backDegree = 90
        }
        withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
            frontDegree = 0
        }
    } else {
        withAnimation(.linear(duration: durationAndDelay)) {
            frontDegree = -90
        }
        withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
            backDegree = 0
        }
    }
}
   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    @State var unlocked = false //aggiunta per il toggle
    
var body: some View {
    
    ZStack {
        CardFront(width: width, height: height, degree: $frontDegree)
        CardBack(width: width, height: height, degree: $backDegree)
    }.onChange(of: unlocked) {
        if !isFlipped { //uso isFlipped così gira una volta soltanto
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    flipCard()
                })
            }
        else {
            print ("non deve ruotare perchè isFlipped sta a true")
            
        }
    }
  
    
    // questo bottone deve essere sostituito, quando il modello di ML riconosce quello che vogliamo fa il toggle di unlocked
    Button("Button TEST FLIP") {
        unlocked.toggle()
        //print(unlocked)
    }
}
}


#Preview {
    Card_Animation()
}

