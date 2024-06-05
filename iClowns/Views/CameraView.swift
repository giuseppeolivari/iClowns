//
//  CameraPreviewView.swift
//  iClowns
//
//  Created by Luigi Penza on 15/05/24.
//

import SwiftUI

struct CameraView: View {
    @State var icvm = ImageClassificationViewModel()
    
    var body: some View {
        ZStack {
            CameraPreviewHolder(captureSession: CaptureManager.shared.session)
                .ignoresSafeArea()
               PredictionView()
               
        }
        .onAppear {
            CaptureManager.shared.controllSession(start: true)
        }
        .onDisappear {
            CaptureManager.shared.controllSession(start: false)
        }
    }
}


