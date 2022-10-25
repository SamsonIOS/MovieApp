// Networking.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// vc
final class ApiFilms {
    private var dataTask: URLSessionDataTask?

    func getMoviesData(filmsUrl: String, completion: @escaping (Result<ModelFilm, Error>) -> ()) {
        guard let url = URL(string: filmsUrl) else { return }
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")

            guard let data = data else {
                print("Данные не получены")
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ModelFilm.self, from: data)
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