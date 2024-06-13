//
//  PredictionView.swift
//  WonderSeek
//
//  Created by Domenico Mennillo on 04/06/24.
//

import SwiftUI
import SwiftData

struct PredictionView: View {
    @Query var attractions: [Attraction]
    
    var body: some View {
        NavigationStack{
            GeometryReader{geometry in
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width/1.3,height: geometry.size.height/8.5)
                        .position(x: geometry.size.width/2,y:geometry.size.height/1.4)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.013, brightness: 0.246))
                    
                    Image("retrofrankobolls")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15 ,height: geometry.size.height * 0.1)
                        .position(x: geometry.size.width/4.8,y:geometry.size.height/1.4)
                    
                    VStack(alignment: .leading) {
                        Text(FrameManager.shared.icvm.confidenceClassificationText.last ?? "null")
                            .foregroundStyle(.white)
                        
                        Text("TAP TO UNLOCK THE STAMP!")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                    }
                    .position(x: geometry.size.width * 0.6 ,y:geometry.size.height/1.4)
                }
            }
        }
    }
}
