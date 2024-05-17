//
//  ContentView.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 15/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var lines: [Line] = []
    @State private var recognizedText: String = ""
    
    var body: some View {
        VStack {
            DrawingView(lines: $lines)
                .frame(width: 300, height: 300)
                .background(Color.white)
                .border(Color.black, width: 1)
            
            HStack {
                Button("Recognize") {
                    let drawingImage = DrawingView(lines: $lines).captureImage()
                    recognizedText = recognizeHandwriting(from: drawingImage) ?? "Recognition failed"
                }
                Button("Clear"){
                    lines = []
                }
            }
            
            Text(recognizedText)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
