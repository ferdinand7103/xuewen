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
        return "Recognition failed: Model initialization failed"
    }

    print("Converting image to pixel buffer...")
    // Resize the image to the size expected by the model (e.g., 28x28 if using MNIST-like data)
    guard let resizedImage = image.resize(to: CGSize(width: 28, height: 28)),
          let buffer = resizedImage.pixelBuffer() else {
        return "Recognition failed: Unable to convert image to pixel buffer"
    }

    print("Making prediction...")
    guard let prediction = try? model.prediction(image: buffer) else {
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

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func pixelBuffer() -> CVPixelBuffer? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        let data = CVPixelBufferGetBaseAddress(buffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        guard let cgContext = context else {
            return nil
        }

        cgContext.translateBy(x: 0, y: CGFloat(height))
        cgContext.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsPushContext(cgContext)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(buffer, .readOnly)

        return buffer
    }
}
