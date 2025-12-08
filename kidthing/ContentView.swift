//
//  ContentView.swift
//  kidthing
//
//  Created by Андрей Поль on 08.12.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var firstTable = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @State private var secondTable = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    var body: some View {
        VStack {
            Text("What is")
            Text("2 x 2?").fontWeight(.bold).padding()
            
            Button("Test1") { }.font(.title2).frame(width: 200, height: 100).background(.red).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 5))
            Button("Test2") { }.font(.title2).frame(width: 200, height: 100).background(.blue).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 5))
            Button("Test3") { }.font(.title2).frame(width: 200, height: 100).background(.yellow).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 5))
            Button("Test3") { }.font(.title2).frame(width: 200, height: 100).background(.green).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 5))
            
        }
    }
}

#Preview {
    ContentView()
}
