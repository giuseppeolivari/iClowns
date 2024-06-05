//
//  PredictionView.swift
//  WonderSeek
//
//  Created by Domenico Mennillo on 04/06/24.
//

import SwiftUI

struct PredictionView: View {
    var body: some View {
        Group{
            GeometryReader{geometry in
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width/1.3,height: geometry.size.height/8.5)
                        .position(x: geometry.size.width/2,y:geometry.size.height/1.4)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.013, brightness: 0.246))
                Image("StampsMini")
                        .position(x: geometry.size.width/4.8,y:geometry.size.height/1.4)
                        
                Text(FrameManager.shared.icvm.confidenceClassificationText.last ?? "null")
                        .foregroundStyle(.white)
                        .position(x: geometry.size.width/2.5,y:geometry.size.height/1.43)
                        
                        
                    NavigationLink(destination: EmptyView(),label: {
                        Text("Tap for more info")
                            .position(x: geometry.size.width/2.1,y:geometry.size.height/1.38)
                            .foregroundColor(.white)
                    
                    })
                    
            }
            }
        }
    }
}

#Preview {
    PredictionView()
}
