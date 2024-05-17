//
//  Extensions.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 15/05/24.
//

//import UIKit

//extension UIImage {
//    func pixelBuffer() -> CVPixelBuffer? {
//        let width = Int(self.size.width)
//        let height = Int(self.size.height)
//        let attributes = [
//            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
//            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
//        ] as CFDictionary
//        var pixelBuffer: CVPixelBuffer?
//        let status = CVPixelBufferCreate(
//            kCFAllocatorDefault,
//            width,
//            height,
//            kCVPixelFormatType_32ARGB,
//            attributes,
//            &pixelBuffer
//        )
//        
//        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
//            return nil
//        }
//        
//        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
//        let pixelData = CVPixelBufferGetBaseAddress(buffer)
//        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(
//            data: pixelData,
//            width: width,
//            height: height,
//            bitsPerComponent: 8,
//            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
//            space: rgbColorSpace,
//            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
//        )
//        
//        context?.translateBy(x: 0, y: CGFloat(height))
//        context?.scaleBy(x: 1.0, y: -1.0)
//        
//        UIGraphicsPushContext(context!)
//        self.draw(in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
//        UIGraphicsPopContext()
//        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
//        
//        return buffer
//    }
//}
