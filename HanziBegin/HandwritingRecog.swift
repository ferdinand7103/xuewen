//
//  asdas.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 15/05/24.
//

import CoreML
import UIKit

func recognizeHandwriting(from image: UIImage) -> String {
    print("Loading model...")
    guard let model = try? HanziRecog1(configuration: .init()) else {
        print("Recognition failed: Model initialization failed")
        return "Recognition failed: Model initialization failed"
    }

    print("Converting image to pixel buffer...")
    guard let buffer = image.pixelBuffer() else {
        print("Recognition failed: Unable to convert image to pixel buffer")
        return "Recognition failed: Unable to convert image to pixel buffer"
    }

    print("Making prediction...")
    guard let prediction = try? model.prediction(image: buffer) else {
        print("Recognition failed: Prediction failed")
        return "Recognition failed: Prediction failed"
    }

    // Extract the recognized text from the prediction's featureValue dictionary
    if let textFeatureValue = prediction.featureValue(for: "target")?.stringValue {
        print("Prediction successful: \(textFeatureValue)")
        return textFeatureValue
    } else {
        print("No text found in prediction.")
        return "Recognition failed: No text found"
    }
}
