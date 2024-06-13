//
//  CameraPreviewView.swift
//  iClowns
//
//  Created by Luigi Penza on 15/05/24.
//

import SwiftUI

struct CameraView: View {
    @State var icvm = ImageClassificationViewModel()
    @Binding var isUnlocking: Bool
    @Environment(\.dismiss) var dismiss
    
    var attraction: Attraction
    
    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreviewHolder(captureSession: CaptureManager.shared.session)
                    .ignoresSafeArea()
                
                let pred = FrameManager.shared.icvm.confidenceClassificationText.last ?? "null"
                
                if !pred.isEmpty {
                    if pred == "Busto di San Gennaro" && attraction.name == "Via Duomo, 147" {
                        PredictionView()
                            .onTapGesture {
                                isUnlocking = true
                                dismiss()
                            }
                    }
                    if pred == "Castel dell'Ovo" && attraction.name == "Via Eldorado, 3" {
                        PredictionView()
                            .onTapGesture {
                                isUnlocking = true
                                dismiss()
                            }
                    }
                    if pred == "Murales Maradona" && attraction.name == "Via Emanuele de Deo, 46" {
                        PredictionView()
                            .onTapGesture {
                                isUnlocking = true
                                dismiss()
                            }
                    }
                    if pred == "Presepe" && attraction.name == "Via S. Gregorio Armeno, 14-52" {
                        PredictionView()
                            .onTapGesture {
                                isUnlocking = true
                                dismiss()
                            }
                    }
                }
            }
            .onAppear {
                CaptureManager.shared.controllSession(start: true)
            }
            .onDisappear {
                CaptureManager.shared.controllSession(start: false)
            }
        }
    }
}


