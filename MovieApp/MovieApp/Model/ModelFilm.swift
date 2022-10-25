// ModelFilm.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// vc
struct ModelFilm: Decodable {
    let films: [Films]

    enum CodingKeys: String, CodingKey {
        case films = "results"
    }
}

/// vc
struct Films: Decodable {
    let title: String?
    let overview: String?
    let filmImage: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case filmImage = "poster_path"
        case rating = "vote_average"
    }
}
