import SwiftUI

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
}
