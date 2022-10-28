// ActorViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Работа с сетью актеров
final class ActorViewModel {
    private enum Constants {
        static let errorProccecing = "Error processing json data:"
    }

    // MARK: Private properties

    private var apiService = ApiFilms()
    private var actors: [ActorInfo] = []

    // MARK: Public Methods

    func fetchActorData(idMovie: Int?, completion: @escaping () -> ()) {
        guard let idMovie = idMovie else { return }
        let urlActor =
            "https://api.themoviedb.org/3/movie/\(idMovie)/credits?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US"

        apiService.getActorData(actorsUrl: urlActor) { [weak self] result in

            switch result {
            case let .success(listOf):
                guard let listOf = listOf else { return }
                self?.actors = listOf.actor
                completion()
            case let .failure(error):
                print(Constants.errorProccecing + "\(error)")
            }
        }
    }

    func numberOfRowsInSection(section: Int) -> Int {
        if actors.count != 0 {
            return actors.count
        }
        return 0
    }

    func cellForRowAt(indexPath: IndexPath) -> ActorInfo {
        actors[indexPath.row]
    }
}
