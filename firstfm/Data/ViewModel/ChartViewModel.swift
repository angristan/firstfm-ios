//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import Foundation


class ChartViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    var isLoading = true

    func getChartingArtists() {
        self.isLoading = true

        var request = URLRequest(url: URL(string: "https://ws.audioscrobbler.com/2.0/?format=json")!)
        let data : Data = "api_key=d404c94c63e190519d70002332f09509&method=chart.getTopArtists&limit=15".data(using: .utf8)!

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                let nsHTTPResponse = response as! HTTPURLResponse
                let statusCode = nsHTTPResponse.statusCode
                print ("status code = \(statusCode)")
                // TODO
            }
            if let error = error {
                print (error)
                // TODO
            }
            if let data = data {
                do{
                    let jsonResponse = try! JSONDecoder().decode(ArtistResponse.self, from: data)

                    DispatchQueue.main.async {
                        self.artists = jsonResponse.artists.artist
                        self.isLoading = false
                    }
                }
            }
        }.resume()
    }
}
