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

struct ArtistView_Previews: PreviewProvider {

    static var previews: some View {
        if let sampleArtist = Self.sampleArtist {
            ArtistView(artist: sampleArtist)
        } else {
            Text("Failed to load sample JSON")
        }
    }

    static var sampleArtist: Artist? {
        guard let url = Bundle.main.url(
                forResource: "SampleArtist",
              withExtension: "json"
        ),
        let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let artist = try? decoder.decode(Artist.self, from: data)
        
        return artist ?? nil
    }
}
