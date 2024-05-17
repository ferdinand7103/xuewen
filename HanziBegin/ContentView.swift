//
//  ContentView.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 17/05/24.
//

//CanvasRepresentable(clear: $clearCanvas, image: $canvasImage)
//    .frame(width: 300, height: 300)
//    .border(Color.black, width: 1)
//    .background(Color.white)

import SwiftUI

struct ContentView: View {
    @State private var clearCanvas = false
    @State private var canvasImage: UIImage?
    @State private var predictionResult: String = ""

    var body: some View {
        VStack {
            CanvasRepresentable(clear: $clearCanvas, image: $canvasImage)
                .edgesIgnoringSafeArea(.all)
                .background(Color.black)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            HStack {
                Button(action: {
                    clearCanvas = true
                    predictionResult = ""
                }) {
                    Text("Clear")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }

                Button(action: {
                    if let image = canvasImage {
                        print("Captured Image Size: \(image.size)")
                        predictionResult = recognizeHandwriting(from: image)
                    } else {
                        predictionResult = "No image to recognize"
                    }
                }) {
                    Text("Recognize")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Button(action: {
                    saveCanvas()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()

            Text(predictionResult)
                .padding()
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(10)
        }
    }

    func saveCanvas() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("No window found")
            return
        }

        if let rootView = window.rootViewController?.view,
           let canvasView = findCanvasView(in: rootView) {
            canvasView.saveCanvasToGallery()
        } else {
            print("CanvasView not found")
        }
    }

    private func findCanvasView(in view: UIView) -> CanvasView? {
        if let canvasView = view as? CanvasView {
            return canvasView
        }
        for subview in view.subviews {
            if let found = findCanvasView(in: subview) {
                return found
            }
        }
        return nil
    }
}

#Preview {
    ContentView()
}
