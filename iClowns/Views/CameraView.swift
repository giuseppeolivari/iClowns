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
            let pred = FrameManager.shared.icvm.confidenceClassificationText.last ?? "null"
            if !pred.isEmpty{
                PredictionView()
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


