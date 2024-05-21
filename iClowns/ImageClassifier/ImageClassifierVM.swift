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

/// View Model for Image Classification
@Observable class ImageClassificationViewModel {
    /// An array to store the image classification results
    var imageClassificationText: [String] = []
    /// Set to hold Combine cancellable objects
    private var cancellable = Set<AnyCancellable>()
    
    /// Classify the given UIImage using the SqueezeNet Core ML model
    /// - Parameter uiImage: The UIImage to be classified
    func classifyImageMLCore(uiImage: UIImage) {
        // Resize the image to the required size
        guard let cvPixelBuffer = buffer(from: uiImage) else { return  }
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
