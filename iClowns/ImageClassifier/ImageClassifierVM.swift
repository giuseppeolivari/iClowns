//
//  ViewModel.swift
//  iClowns
//
//  Created by Luigi Penza on 14/05/24.
//

import Foundation
import Combine
import Vision
import UIKit

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func convertToBuffer() -> CVPixelBuffer? {
        
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault, Int(self.size.width),
            Int(self.size.height),
            kCVPixelFormatType_32ARGB,
            attributes,
            &pixelBuffer)
        
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(
            data: pixelData,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

/// View Model for Image Classification
@Observable class ImageClassificationViewModel {
    /// An array to store the image classification results
    var confidenceClassificationText: [String] = []
    var findStamp : Bool = false
    /// Set to hold Combine cancellable objects
    private var cancellable = Set<AnyCancellable>()
    
    /// Classify the given UIImage using the SqueezeNet Core ML model
    /// - Parameter uiImage: The UIImage to be classified
    func classifyImageMLCore(uiImage: UIImage) {
        // Resize the image to the required size
        //guard let cvPixelBuffer = buffer(from: uiImage) else { return  }
        let resizeImage = uiImage.resizeImageTo(size: CGSize(width: 224, height: 224))
        guard let cvPixelBuffer = resizeImage?.convertToBuffer() else { return  }
        
        do {
           
            // Load the SqueezeNet Core ML model
            let model = try ImageClassificationNapoli(configuration: MLModelConfiguration())
            
            // Perform image classification using the model
            let prediction = try model.prediction(image: cvPixelBuffer)
            
            // Append the classification result to the array
            self.appendConfidenceClassification(confidence: prediction.targetProbability)
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Append the image classification result to the array and update the UI
    /// - Parameter imageData: The image classification result to be appended
    private func appendConfidenceClassification(confidence: [String:Double]) {
        let confiltr = confidence.filter{ $0.value > 0.99 }
        
        let dictionaryString = confiltr.map { "\($0.key)" }.joined(separator: ", ")
        
        
        Just(dictionaryString)
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.confidenceClassificationText.append(value)
                
            }
            .store(in: &cancellable)
    }
}
