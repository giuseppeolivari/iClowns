//
//  FrameManager.swift
//  iClowns
//
//  Created by Luigi Penza on 15/05/24.

import SwiftUI
import Observation
import AVFoundation

@Observable class FrameManager: NSObject {
    private let classificationQueue = DispatchQueue(label: "classificationQueue")
    private var timer: DispatchSourceTimer?
    private var latestBuffer: CVPixelBuffer?
    
    static let shared = FrameManager()
    
    let icvm = ImageClassificationViewModel()
    
    var current: CVPixelBuffer?
    
    let videoOutputQueue = DispatchQueue(label: "com.iClowns.VideoOutPutQ", qos: .userInitiated,
                                         attributes: [], autoreleaseFrequency: .workItem)
    
    private override init() {
        super.init()
        startTimer()
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
    
    func startTimer() {
        timer = DispatchSource.makeTimerSource(queue: classificationQueue)
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler { [weak self] in
            self?.classifyLatestFrame()
        }
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func classifyLatestFrame() {
        guard let buffer = latestBuffer else { return }
        if let uiImage = convert(pixelBuffer: buffer) {
            DispatchQueue.main.async {
                self.icvm.classifyImageMLCore(uiImage: uiImage)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
            
            classificationQueue.async {
                self.latestBuffer = buffer
            }
        }
    }
}
