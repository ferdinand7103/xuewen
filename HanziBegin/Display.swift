//
//  Display.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 24/05/24.
//

import SwiftUI

struct Display: View {
    @Binding var num: Int
    @State var HanziPinyin: [String: [String]] = ["一": ["yī", "One", "6055946"], "几": ["jǐ", "Several", "cameo-apples-1"], "八": ["bā", "Eight", "8913811"], "十": ["shí", "Ten", "st,small,507x507-pad,600x600,f8f8f8.u2"], "了": ["le", "Finish", "pngtree-3d-green-check-mark-icon-png-image_6552255"]]
    @State private var clearCanvas = false
    @State private var canvasImage: UIImage?
    @State private var predictionResult: String = ""

    var body: some View {
        let keys = HanziPinyin.keys.sorted()
        let values = keys.map { HanziPinyin[$0]! }
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack(alignment: .center) {
                    Text(keys[num])
                        .font(.system(size: 100))
                        .bold()
                    Text(values[num][0])
                        .font(.system(size: 100))
                        .bold()
                    Text(values[num][1])
                        .font(.system(size: 100))
                        .bold()
                }
                .frame(width: 405, height: 425)
                .padding([.leading, .bottom], 30)
                .border(Color.black, width: 5)
                Image(values[num][2])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 435, height: 425)
                    .border(Color.black, width: 5)
            }
            .padding(.leading, 100)
            ZStack {
                CanvasRepresentable(clear: $clearCanvas, image: $canvasImage)
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.white)
                    .frame(width: 850, height: 850)
                Button(action: {
                    clearCanvas = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        clearCanvas = false
                    }
                    predictionResult = ""
                }) {
                    Text(Image(systemName: "eraser"))
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(50)
                }
                .padding(.bottom, 700)
                .padding(.trailing, 700)
                Button(action: {
                    if let canvasView = getCanvasView() {
                        let image = canvasView.asImage()
                        canvasImage = image
                        predictionResult = recognizeHandwriting(from: image)
                        print("Prediction : \(predictionResult)")
                        if predictionResult == keys[num] {
                            num = (num + 1) % keys.count
                        }
                        clearCanvas = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            clearCanvas = false
                        }
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
                .padding(.bottom, 700)
                .padding(.leading, 450)
            }
        }
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

//#Preview {
//    Display(num: 0)
//}
