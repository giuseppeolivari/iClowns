//
//  ViewModel.swift
//  iClowns
//
//  Created by Luigi Penza on 14/05/24.
//

import Foundation
import Combine
import Vision
import VisionKit
import SwiftUI
import PhotosUI

//// Resize uiImage
//public extension UIImage {
//    /// Resize image while keeping the aspect ratio. Original image is not modified.
//    func resize(_ width: Int, _ height: Int) -> UIImage {
//        // Keep aspect ratio
//        let maxSize = CGSize(width: width, height: height)
//
//        let availableRect = AVFoundation.AVMakeRect(
//            aspectRatio: self.size,
//            insideRect: .init(origin: .zero, size: maxSize)
//        )
//        let targetSize = availableRect.size
//
//        // Set scale of renderer so that 1pt == 1px
//        let format = UIGraphicsImageRendererFormat()
//        format.scale = 1
//        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
//
//        // Resize the image
//        let resized = renderer.image { _ in
//            self.draw(in: CGRect(origin: .zero, size: targetSize))
//        }
//
//        return resized
//    }
//}
//// Buffer uiImage
//func buffer(from image: UIImage) -> CVPixelBuffer? {
//  let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
//  var pixelBuffer : CVPixelBuffer?
//  let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
//  guard (status == kCVReturnSuccess) else {
//    return nil
//  }
//
//  CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//  let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
//
//  let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//  let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//
//  context?.translateBy(x: 0, y: image.size.height)
//  context?.scaleBy(x: 1.0, y: -1.0)
//
//  UIGraphicsPushContext(context!)
//  image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
//  UIGraphicsPopContext()
//  CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//
//  return pixelBuffer
//}

//func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
//    let renderer = UIGraphicsImageRenderer(size: targetSize)
//    return renderer.image { _ in
//        image.draw(in: CGRect(origin: .zero, size: targetSize))
//    }
//}

/// View Model for Image Classification
class ImageClassificationViewModel : ObservableObject {
    /// The selected item from the photo picker
    //@Published var photoPickerItem : PhotosPickerItem? = nil
    /// The UIImage representation of the selected image
    //@Published var uiImage : UIImage?
    /// An array to store the image classification results
    @Published var imageClassificationText: [String] = []
    /// Set to hold Combine cancellable objects
    private var cancellable = Set<AnyCancellable>()
    
    /// Classify the given UIImage using the SqueezeNet Core ML model
    /// - Parameter uiImage: The UIImage to be classified
//    func classifyImageMLCore(uiImage: UIImage) {
//        // Resize the image to the required size
//        //let resizeImage = uiImage.resize(224, 224)
//        let resizeImage = resizeImage(uiImage, targetSize: CGSize(width: 224, height: 224))
//        guard let cvPixelBuffer = buffer(from: resizeImage) else { return  }
//        do {
//            // Load the SqueezeNet Core ML model
//            let model = try Resnet50Int8LUT(configuration: MLModelConfiguration())
//            
//            // Perform image classification using the model
//            let prediction = try model.prediction(image: cvPixelBuffer)
//            
//            // Append the classification result to the array
//            self.appendImageClassification(imageData: prediction.classLabel)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
    
    /// Classify the given UIImage using the SqueezeNet Core ML model
    /// - Parameter uiImage: The UIImage to be classified
    func classifyImageMLCoreBuffer(cvPixelBuffer: CVPixelBuffer) {
        do {
            // Load the SqueezeNet Core ML model
            let model = try Resnet50Int8LUT(configuration: MLModelConfiguration())
            
            // Perform image classification using the model
            let prediction = try model.prediction(image: cvPixelBuffer)
            
            // Append the classification result to the array
            self.appendImageClassification(imageData: prediction.classLabel)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Append the image classification result to the array and update the UI
    /// - Parameter imageData: The image classification result to be appended
    func appendImageClassification(imageData: String) {
        print(imageData)
        Just(imageData)
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.imageClassificationText.append(value)
            }
            .store(in: &cancellable)
    }
}
