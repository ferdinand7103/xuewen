//
//  Display.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 24/05/24.
//

import SwiftUI

struct Display: View {
    var num: Int
    @State var HanziPinyin : [String: String] = ["一": "yī", "们": "mén", "不": "bù", "他": "tā", "分": "fēn",]
    @State private var clearCanvas = false
    @State private var canvasImage: UIImage?
    @State private var predictionResult: String = ""
    
    var body: some View {
        var key : [String] = getKeys()
        var value : [String] = getValues()
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack {
                    Text(key[num])
                        .font(.system(size: 100))
                    .bold()
                    Text(value[num])
                        .font(.system(size: 100))
                        .bold()
                }
                .frame(width: 405, height: 425)
                .padding()
                .border(Color.black, width: 5)
                Image("6055946")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 435, height: 425)
                    .border(Color.black, width: 5)
            }
            ZStack {
                CanvasRepresentable(clear: $clearCanvas, image: $canvasImage)
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.white)
                    .frame(width: 760, height: 850)
                    .border(Color.black, width: 1)
                Button(action: {
                    clearCanvas = true
                    predictionResult = ""
                }) {
                    Text(Image(systemName: "eraser"))
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(50)
                }
                .padding(.bottom, 650)
                .padding(.trailing, 600)
                Button(action: {
                    if let canvasView = getCanvasView() {
                        let image = canvasView.asImage()
                        canvasImage = image
                        saveImageToGallery(image: image)
                        predictionResult = recognizeHandwriting(from: image)
                        print("Prediction : \(predictionResult)")
                        clearCanvas = true
                    } else {
                        print("Prediction not found")
                    }
                }) {
                    Text(Image(systemName: "checkmark"))
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(50)
                }
                .padding(.bottom, 650)
                .padding(.leading, 600)
            }
        }
    }
    
    func getKeys() -> Array<String> {
        var keys : [String] = []
        for hanzi in HanziPinyin.keys {
            keys.append(hanzi)
        }
        return keys
    }
    
    func getValues() -> Array<String> {
        var values : [String] = []
        for pinyin in HanziPinyin.values {
            values.append(pinyin)
        }
        return values
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
    Display(num: 0)
}
