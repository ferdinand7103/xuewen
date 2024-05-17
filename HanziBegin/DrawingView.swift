//
//  DrawView.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 15/05/24.
//

//import SwiftUI
//
//struct DrawingView: UIViewRepresentable {
//    @Binding var lines: [Line]
//    @Binding var drawingUIView: UIView?
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    class Coordinator: NSObject {
//        var parent: DrawingView
//        var uiView: UIView?
//
//        init(_ parent: DrawingView) {
//            self.parent = parent
//        }
//    }
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        view.backgroundColor = .clear
////        view.isUserInteractionEnabled = true
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        context.coordinator.uiView = uiView // Set the UIView reference here
//        // Remove existing drawing layers
//        uiView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//
//        // Render the lines onto the view
//        for line in lines {
//            let path = UIBezierPath()
//            path.move(to: line.points.first!)
//            for point in line.points.dropFirst() {
//                path.addLine(to: point)
//            }
//
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = path.cgPath
//            shapeLayer.strokeColor = UIColor.black.cgColor
//            shapeLayer.lineWidth = 10
//            shapeLayer.fillColor = UIColor.clear.cgColor
//
//            uiView.layer.addSublayer(shapeLayer)
//        }
//    }
//
//    func captureImage(from uiView: UIView) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: uiView.bounds)
//        return renderer.image { rendererContext in
//            uiView.layer.render(in: rendererContext.cgContext)
//        }
//    }
//}
//
//struct Line {
//    var points: [CGPoint]
//}
//
//extension UIView {
//    func asImage() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
//        }
//    }
//}
//
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
//
