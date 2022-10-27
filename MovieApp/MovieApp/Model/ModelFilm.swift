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
    let id: Int?
    let backdropImage: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case filmImage = "poster_path"
        case rating = "vote_average"
        case id
        case backdropImage = "backdrop_path"
        case date = "release_date"
    }
}

/// Модель  массив Актеры
struct ActorModel: Decodable {
    let actor: [ActorInfo]

    private enum CodingKeys: String, CodingKey {
        case actor = "cast"
    }
}

/// Модель Актеры
struct ActorInfo: Decodable {
    let name: String?
    let actorImage: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case actorImage = "profile_path"
    }
}
