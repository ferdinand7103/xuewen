//
//  toIMG.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 17/05/24.
//

import UIKit

func saveImageToDocuments(image: UIImage, fileName: String) {
    guard let data = image.pngData() else { return }
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    if let documentsURL = urls.first {
        let fileURL = documentsURL.appendingPathComponent(fileName)
        try? data.write(to: fileURL)
    }
}
