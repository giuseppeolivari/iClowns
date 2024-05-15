//
//  CameraView.swift
//  iClowns
//
//  Created by Luigi Penza on 15/05/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    var body: some View {
        ZStack {
            CameraPreviewHolder(captureSession: CaptureManager.shared.session)
                .ignoresSafeArea()
        }
        .onAppear {
            CaptureManager.shared.controllSession(start: true)
        }
        .onDisappear {
            CaptureManager.shared.controllSession(start: false)
        }
    }
    
    struct PreviewView: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
