//
//  SearchView.swift
//  firstfm
//
//  Created by Stanislas Lange on 16/06/2021.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchString: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Start typing",
                          text: $searchString,
                          onCommit: { self.performSearch() })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: { self.performSearch() }) {
                    Image(systemName: "magnifyingglass")
                }
            }.padding()
            Spacer()
        }
    }
    
    func performSearch() {
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
