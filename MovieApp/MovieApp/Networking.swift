// Networking.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Работа с сетью
final class ApiFilms {
    // MARK: Constants

    private enum Constants {
        static let response = "Response status code:"
        static let emptyResponse = "Empty Response"
        static let dontGetData = "Данные не получены"
    }

    // MARK: Private properties

    private var dataTask: URLSessionDataTask?

    // MARK: Public Methods

    func getActorData(actorsUrl: String, completion: @escaping (Result<Actor?, Error>) -> ()) {
        universalFunc(url: actorsUrl, completion: completion)
    }

    func getMoviesData(filmsUrl: String, completion: @escaping (Result<Movie?, Error>) -> ()) {
        universalFunc(url: filmsUrl, completion: completion)
    }

    private func universalFunc<T: Decodable>(url: String, completion: @escaping (Result<T?, Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print(Constants.emptyResponse)
                return
            }

            guard let data = data else {
                print(Constants.dontGetData)
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
