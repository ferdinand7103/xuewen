//
//  Canvas.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 17/05/24.
//

import SwiftUI
import UIKit

struct CanvasRepresentable: UIViewRepresentable {
    @Binding var clear: Bool
    @Binding var image: UIImage?

    func makeUIView(context: Context) -> CanvasView {
        let canvasView = CanvasView()
        return canvasView
    }

    func updateUIView(_ uiView: CanvasView, context: Context) {
        if clear {
            uiView.clearCanvas()
            clear = false
        } else {
            DispatchQueue.main.async {
                self.image = uiView.asImage()
            }
        }
    }
}

class CanvasView: UIView {
    var lineColor: UIColor!
    var lineWidth: CGFloat!
    var path: UIBezierPath!
    var touchPoint: CGPoint!
    var startingPoint: CGPoint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        
        if lineColor == nil {
            lineColor = UIColor.black
        }
        if lineWidth == nil {
            lineWidth = 10
        }
        if path == nil {
            path = UIBezierPath()
        }
        
        self.backgroundColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startingPoint = touch?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
        path.move(to: startingPoint)
        path.addLine(to: touchPoint)
        startingPoint = touchPoint
        
        drawShapeLayer()
    }
    
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clearCanvas() {
        path?.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            self.backgroundColor?.setFill()
            rendererContext.fill(bounds)
            self.layer.render(in: rendererContext.cgContext)
        }
    }
}

