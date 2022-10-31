// Movies.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Работа с сетью фильмов
final class NetworkLayer {
    // MARK: Constants

    private enum Constants {
        static let errorProcessing = "Error processing json data:"
        static let url =
            "https://api.themoviedb.org/3/movie/popular?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US&page=1"
    }

    // MARK: Private Properties

    private var apiService = ApiFilms()
    private var popularMovies: [Movies] = []

    // MARK: Public properties

    var filmUrl = Constants.url

    // MARK: Public Methods

    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        apiService.getMoviesData(filmsUrl: filmUrl) { [weak self] result in

            switch result {
            case let .success(listOf):
                guard let listOf = listOf else { return }
                self?.popularMovies = listOf.movies
                completion()
            case let .failure(error):
                print(Constants.errorProcessing + "\(error)")
            }
        }
    }

    func numberOfRowsInSection(section: Int) -> Int {
        if popularMovies.count != 0 {
            return popularMovies.count
        }
        return 0
    }

    func cellForRowAt(indexPath: IndexPath) -> Movies {
        popularMovies[indexPath.row]
    }
}
