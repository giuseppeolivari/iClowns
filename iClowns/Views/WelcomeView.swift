//
//  WelcomeView.swift
//  WonderSeek
//
//  Created by Giuseppe Olivari on 11/06/24.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        VStack{
            VStack {
               
                Text("Welcome to WonderSeek!")
                    .font(.largeTitle)
                    .bold()
            } .padding(.bottom, 50)
            
            
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.406, green: 0.256, blue: 0.596))
                    
                    VStack (alignment: .leading) {
                        Text("Find the points of interest all around you ")
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.leading, 10.0)
                            .frame(width: 215)
                        
                    }
                } .padding(.bottom, 15)
                //TODO: next
                
                HStack {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.406, green: 0.256, blue: 0.596))
                        
                        
                    VStack (alignment: .leading){
                        Text("Scan the items to unlock the amazing custom stamps")
                            .font(.title2)
                            .fontWeight(.medium)
                            .frame(width: 225)
                        
                    }
                } .padding(.bottom, 15)
                
                HStack {
                    Image(systemName: "exclamationmark.bubble")
                        .font(.system(size: 33))
                        .foregroundColor(Color(red: 0.406, green: 0.256, blue: 0.596))
                        
                    VStack (alignment: .leading) {
                        Text("Get notified when you’re close to the points of interest.")
                            .font(.title2)
                            .fontWeight(.medium)
                            .frame(width: 225)
                        
//
                    }
                } .padding(.bottom, 40)
                
                
             
                
                
            }
            // .padding(.leading)
            VStack {
                Text("Ready to discover?")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                
                
                Button(action: {
                    isOnboarding = false
                    dismiss()
                        
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width:250, height:70)
                            .foregroundColor(Color(red: 0.406, green: 0.256, blue: 0.596))
                        
                        Text("Let's go!")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
        }
    }
}


#Preview {
    WelcomeView()
}
