//
//  DrawView.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 15/05/24.
//

import SwiftUI

struct DrawingView: UIViewRepresentable {
    @Binding var lines: [Line]

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: DrawingView

        init(parent: DrawingView) {
            self.parent = parent
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            switch gesture.state {
            case .began:
                parent.lines.append(Line(points: [point]))
            case .changed:
                parent.lines[parent.lines.count - 1].points.append(point)
            case .ended:
                break
            default:
                break
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(panGesture)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let sublayers = uiView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        for line in lines {
            let path = UIBezierPath()
            path.move(to: line.points.first!)
            for point in line.points.dropFirst() {
                path.addLine(to: point)
            }
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.lineWidth = 10
            shapeLayer.fillColor = UIColor.clear.cgColor
            uiView.layer.addSublayer(shapeLayer)
        }
    }

    func captureImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 300, height: 300))
        return renderer.image { rendererContext in
            let uiView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            let coordinator = Coordinator(parent: self)
            let panGesture = UIPanGestureRecognizer(target: coordinator, action: #selector(Coordinator.handlePan(_:)))
            panGesture.maximumNumberOfTouches = 1
            panGesture.delegate = coordinator
            uiView.addGestureRecognizer(panGesture)
            uiView.layer.render(in: rendererContext.cgContext)
        }
    }
}

struct Line {
    var points: [CGPoint]
}
