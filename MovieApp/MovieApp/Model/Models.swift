// Models.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Массив фильмов
struct Movie: Decodable {
    let movies: [Movies]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

/// Модель для получении информации о фильмах
struct Movies: Decodable {
    let title: String?
    let overview: String?
    let movieImage: String?
    let rating: Double?
    let id: Int?
    let backdropImage: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case movieImage = "poster_path"
        case rating = "vote_average"
        case id
        case backdropImage = "backdrop_path"
        case date = "release_date"
    }
}

/// Массив актеров
struct Actor: Decodable {
    let actors: [ActorInfo]

    private enum CodingKeys: String, CodingKey {
        case actors = "cast"
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
