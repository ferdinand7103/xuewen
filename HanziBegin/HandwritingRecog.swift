import CoreML
import UIKit

func recognizeHandwriting(from image: UIImage) -> String {
    print("Loading model...")
    guard let model = try? HanziRecog3(configuration: .init()) else {
        return "Recognition failed: Model initialization failed"
    }

    print("Resizing image...")
    guard let resizedImage = image.resize(to: CGSize(width: 28, height: 28)) else {
        return "Recognition failed: Unable to resize image"
    }

    print("Converting image to pixel buffer...")
    guard let buffer = resizedImage.pixelBuffer() else {
        return "Recognition failed: Unable to convert image to pixel buffer"
    }

    print("Making prediction...")
    guard let prediction = try? model.prediction(image: buffer) else {
        return "Recognition failed: Prediction failed"
    }

    if let textFeatureValue = prediction.featureValue(for: "target")?.stringValue {
        print("Prediction successful: \(prediction.targetProbability)")
        return textFeatureValue
    } else {
        print("No text found in prediction.")
        return "Recognition failed: No text found"
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
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
        guard let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }

        UIGraphicsPushContext(context)
        defer { UIGraphicsPopContext() }
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, .readOnly)

        return buffer
    }
}

