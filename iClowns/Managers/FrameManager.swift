//
//  FrameManager.swift
//  iClowns
//
//  Created by Luigi Penza on 15/05/24.

import SwiftUI
import Observation
import AVFoundation

@Observable class FrameManager: NSObject {
    static let shared = FrameManager()
    
    var current: CVPixelBuffer?
    
    let videoOutputQueue = DispatchQueue(label: "com.iClowns.VideoOutPutQ", qos: .userInitiated,
                                         attributes: [], autoreleaseFrequency: .workItem)
    
    private override init() {
        super.init()
        CaptureManager.shared.set(self, queue: videoOutputQueue)
    }
}

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func convert(pixelBuffer: CVPixelBuffer) -> UIImage? {
        // Create a CIImage from the CVPixelBuffer
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Create a CIContext
        let ciContext = CIContext()
        
        // Create a CGImage from the CIImage
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        // Create and return a UIImage from the CGImage
        return UIImage(cgImage: cgImage)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let buffer = sampleBuffer.imageBuffer {
            let icvm = ImageClassificationViewModel()
            DispatchQueue.main.async {
                Thread.sleep(forTimeInterval: 1.0)
                self.current = buffer

                icvm.classifyImageMLCore(uiImage: self.convert(pixelBuffer: buffer)!)
                // riconoscimento
            }
        }
    }
}
