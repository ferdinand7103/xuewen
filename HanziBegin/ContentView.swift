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
                .background(Color.white)
                .frame(width: 300, height: 300)
                .border(Color.black, width: 1)
            
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
                    if let canvasView = getCanvasView() {
                        let image = canvasView.asImage()
                        canvasImage = image
                        saveImageToGallery(image: image) // Save the input image for debugging
                        predictionResult = recognizeHandwriting(from: image)
                        print("Prediction : \(predictionResult)")
                    } else {
                        print("Prediction not found")
                    }
                }) {
                    Text("Recognize")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Button(action: {
                    if let canvasView = getCanvasView() {
                        canvasView.saveCanvasToGallery()
                    } else {
                        print("CanvasView not found")
                    }
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

    private func saveImageToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    private func getCanvasView() -> CanvasView? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("No window found")
            return nil
        }

        if let rootView = window.rootViewController?.view {
            return findCanvasView(in: rootView)
        } else {
            print("Root view not found")
            return nil
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
