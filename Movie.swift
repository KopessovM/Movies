//
//  Movie.swift
//  Movies
//
//  Created by Madi Kupesov on 2/6/21.
//

import Foundation

struct Movie {
    var id: Int
    var posterPath: String
    var name: String
    var date: String
    var overview: String
    init(json: [String: Any]) throws {
        guard let id = json["id"] as? Int, let posterPath = json["poster_path"] as? String, let name = json["original_title"] as? String, let date = json["release_date"] as? String, let overview = json["overview"] as? String
        else {
            throw NSError(domain: "Error parsing json", code: 0, userInfo: nil)
        }
        self.id = id
        self.posterPath = posterPath
        self.name = name
        self.date = date
        self.overview = overview
    }
}
