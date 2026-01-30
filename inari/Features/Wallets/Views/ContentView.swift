//
//  ContentView.swift
//  inari
//
//  Created by Giuliano Rasper on 27.12.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.tint)

                Text("Inari")
                    .font(.largeTitle)
                    .bold()

                Text("Budgeting Made Simple")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()
                    .frame(height: 40)

                Text("Hello World")
                    .font(.title2)
                    .padding()
                    .background(.tint.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .navigationTitle("Welcome")
        }
    }
}

#Preview {
    ContentView()
}
