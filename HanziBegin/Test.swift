//
//  Test.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 24/05/24.
//

import SwiftUI

func HanziPinyin() {
    @State var HanziPinyin : [String: String] = ["一": "yī"]
    
    for (hanzi, pinyin) in HanziPinyin {
        print("\(hanzi): \(pinyin)")
    }
}
