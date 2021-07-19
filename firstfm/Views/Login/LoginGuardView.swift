//
//  LoginGuard.swift
//  firstfm
//
//  Created by Stanislas Lange on 06/07/2021.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Press to dismiss") {
            presentationMode.wrappedValue.dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

struct LoginGuardView: View {
    @State private var showingSheet = false

    var body: some View {
        VStack {
            Text("Please login to access your stats!")

            Button(action: {
                showingSheet.toggle()
            }) {
                LoginButton()
            }
            .sheet(isPresented: $showingSheet) {
                LoginView()
            }
        }
    }
}
