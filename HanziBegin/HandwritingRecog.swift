//
//  asdas.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 15/05/24.
//

import CoreML
import UIKit

func recognizeHandwriting(from image: UIImage) -> String {
    guard let model = try? HanziRecog1(configuration: .init()) else {
        return "Recognition failed: Model initialization failed"
    }

    guard let buffer = image.pixelBuffer() else {
        return "Recognition failed: Unable to convert image to pixel buffer"
    }

    guard let prediction = try? model.prediction(image: buffer) else {
        return "Recognition failed: Prediction failed"
    }

    // Extract the recognized text from the prediction's featureValue dictionary
    if let textFeatureValue = prediction.featureValue(for: "target")?.stringValue {
        return textFeatureValue
    } else {
        return "Recognition failed: No text found"
    }
}

