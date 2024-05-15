//
//  FrameManager.swift
//  iClowns
//
//  Created by Luigi Penza on 15/05/24.

import AVFoundation

class FrameManager: NSObject, ObservableObject {
    
    static let shared = FrameManager()
    
    @Published var current: CVPixelBuffer?
    
    let videoOutputQueue = DispatchQueue(label: "com.sajjad.VideoOutPutQ",
                                         qos: .userInitiated,
                                         attributes: [],
                                         autoreleaseFrequency: .workItem)
    
    private override init() {
        super.init()
        CaptureManager.shared.set(self, queue: videoOutputQueue)
    }
}

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        if let buffer = sampleBuffer.imageBuffer {
            let icViewModel = ImageClassificationViewModel()
            DispatchQueue.main.async {
                self.current = buffer
                icViewModel.classifyImageMLCoreBuffer(cvPixelBuffer: buffer)
            }
        }
    }
}

