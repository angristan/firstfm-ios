//
//  Artist.swift
//  firstfm
//
//  Created by Stanislas Lange on 15/06/2021.
//

import SwiftUI
import Kingfisher

struct ArtistView: View {
    let artist: Artist
    
    var body: some View {
        HStack {
            KFImage(URL(string: artist.image[0].url )!).resizable().aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
        }.navigationTitle(artist.name)
    }
}
