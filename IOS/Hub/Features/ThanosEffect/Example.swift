//
//  Example.swift
//  Hub
//
//  Created by John Robert Prince on 11.05.2025.
//

import SwiftUI

struct Example: View {
    @State private var array = ["Hello", "Privet", "What the fuck", "Analnimus write your dick"]
    @State private var snapEffect = false
    @State private var isRemoved: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if !isRemoved {
                    Group {
                        Image(.margoRobby)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipped()
                            .disintegrationEffect(isDeleted: snapEffect) {
                                withAnimation(.snappy) {
                                    //isRemoved = true
                                }
                            }
                        
                        Button("Remove Item") {
                            snapEffect = true
                        }
                    }
                }
            }
            .navigationTitle("Disintegration Effect")
        }
    }
}

#Preview {
    Example()
}
