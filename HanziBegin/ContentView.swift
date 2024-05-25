//
//  ContentView.swift
//  HanziBegin
//
//  Created by Ferdinand Jacques on 17/05/24.
//

import SwiftUI

struct ContentView: View {
    @State var num = 0

    var body: some View {
        Display(num: num)
    }
}

#Preview {
    ContentView()
}
