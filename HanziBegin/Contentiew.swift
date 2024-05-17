//
//  ContentView.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 15/05/24.
//

//import SwiftUI
//import Photos
//
//struct Contentiew: View {
//    @State private var lines: [Line] = []
//    @State private var recognizedText: String = ""
//    @State private var drawingUIView: UIView?
//
//    var body: some View {
//        VStack {
//            DrawingView(lines: $lines, drawingUIView: $drawingUIView) // Pass binding to drawingUIView
//                .frame(width: 300, height: 300)
//                .background(Color.white)
//                .border(Color.black, width: 1)
//                .gesture(DragGesture(minimumDistance: 0)
//                    .onChanged({ value in
//                        // Append the point to the lines array when the user draws
//                        let currentPoint = value.location
//                        if let lastLineIndex = self.lines.indices.last {
//                            self.lines[lastLineIndex].points.append(currentPoint)
//                        } else {
//                            self.lines.append(Line(points: [currentPoint]))
//                        }
//                    })
//                )
//
//            HStack {
//                Button("Recognize") {
//                    print("a")
//                    guard let drawingUIView = drawingUIView else {
//                        return
//                    }
//                    print("s")
//                    let drawingImage = drawingUIView.asImage()
//                    print("d")
//                    recognizedText = recognizeHandwriting(from: drawingImage) ?? "Recognition failed"
//                    print("f")
//                    saveToGallery(image: drawingImage)
//                    print("g")
//                }
//                Button("Clear"){
//                    lines = []
//                }
//            }
//
//            Text(recognizedText)
//                .padding()
//        }
//    }
//    
//    private func saveToGallery(image: UIImage) {
//        PHPhotoLibrary.shared().performChanges {
//            PHAssetChangeRequest.creationRequestForAsset(from: image)
//        } completionHandler: { success, error in
//            if success {
//                print("Image saved to gallery successfully.")
//            } else if let error = error {
//                print("Error saving image to gallery: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
