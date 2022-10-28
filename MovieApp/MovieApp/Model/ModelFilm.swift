// ModelFilm.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Массив фильмов
struct ModelFilm: Decodable {
    let films: [Films]

    enum CodingKeys: String, CodingKey {
        case films = "results"
    }
}

/// Модель для получении информации о фильмах
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

/// Массив актеров
struct ActorModel: Decodable {
    let actor: [ActorInfo]

    private enum CodingKeys: String, CodingKey {
        case actor = "cast"
    }
}

/// Модель для получения актеров и их имен
struct ActorInfo: Decodable {
    let name: String?
    let actorImage: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case actorImage = "profile_path"
    }
}
