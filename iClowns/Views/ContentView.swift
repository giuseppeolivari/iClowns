//
//  ContentView.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 13/05/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject private var icViewModel = ImageClassificationViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Image(uiImage: icViewModel.uiImage ?? UIImage(imageLiteralResourceName: "cat"))
                .resizable()
                .frame(width:300,height:400)
                .cornerRadius(15)
            
            PhotosPicker("Select photo", selection: $icViewModel.photoPickerItem,matching: .all(of: [.images]))
            
            Button {
                icViewModel.classifyImageMLCore(uiImage: icViewModel.uiImage ?? UIImage(imageLiteralResourceName: "cat"))
            } label: {
                Text("Classify Image")
                    .padding()
                    .foregroundColor(.yellow)
                    .background(.black)
                    .cornerRadius(8)
            }

            Text(icViewModel.imageClassificationText.first ?? "")
            Text(icViewModel.imageClassificationText.last ?? "")
        }
        .onChange(of: icViewModel.photoPickerItem, perform: { newValue in
            Task {
                do{
                    
                    let data = try await icViewModel.photoPickerItem?.loadTransferable(type: Data.self)
                    
                    guard let unwrapData = data else {
                        print("Error")
                        return
                        
                    }
                    
                    icViewModel.uiImage = UIImage(data: unwrapData)

                }catch let error{
                    print(error.localizedDescription)
                }
                
            }
        })
        .navigationTitle("Image Classification")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
