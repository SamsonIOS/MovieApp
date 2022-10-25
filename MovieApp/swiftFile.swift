// swiftFile.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Доп Файл
final class MovieViewModel {
    private var apiService = ApiFilms()
    private var popularMovies: [Films] = []
    var filmUrl =
        "https://api.themoviedb.org/3/movie/popular?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US&page=1"

    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        apiService.getMoviesData(filmsUrl: filmUrl) { [weak self] result in

            switch result {
            case let .success(listOf):
                self?.popularMovies = listOf.films
                completion()
            case let .failure(error):
                print("Error processing json data: \(error)")
            }
        }
    }

    func numberOfRowsInSection(section: Int) -> Int {
        if popularMovies.count != 0 {
            return popularMovies.count
        }
        return 0
    }

    func cellForRowAt(indexPath: IndexPath) -> Films {
        popularMovies[indexPath.row]
    }
}
