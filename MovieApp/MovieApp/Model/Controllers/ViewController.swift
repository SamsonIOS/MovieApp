// ViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран со списком фильмов
final class ViewController: UIViewController {
    // MARK: Constants

    private enum Url {
        static let polularMovie =
            "https://api.themoviedb.org/3/movie/popular?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US&page=1"
        static let topRatedMovie =
            "https://api.themoviedb.org/3/movie/top_rated?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US&page=1"
        static let upComingMovie =
            "https://api.themoviedb.org/3/movie/upcoming?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US&page=1"
    }

    private enum ButtonsTitle {
        static let popular = "Популярные"
        static let topRating = "Топ рейтинга"
        static let upComing = "Новинки"
        static let emptyText = ""
        static let date = "Дата выхода: "
    }

    private enum CellId {
        static let id = "movieCell"
    }

    // MARK: Private properties

    private var viewModel = MovieViewModel()

    private lazy var popularButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle(ButtonsTitle.popular, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        button.tag = 0
        return button
    }()

    private lazy var topRatingsButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle(ButtonsTitle.topRating, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()

    private lazy var latestButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle(ButtonsTitle.upComing, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: CellId.id)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = ButtonsTitle.emptyText
    }

    // MARK: Action Buttons

    @objc private func action(sender: UIButton) {
        switch sender.tag {
        case 0:
            let url = Url.polularMovie
            viewModel.filmUrl = url
            loadPopularMoviesData()
        case 1:
            let url = Url.topRatedMovie
            viewModel.filmUrl = url
            loadPopularMoviesData()
        case 2:
            let url = Url.upComingMovie
            viewModel.filmUrl = url
            loadPopularMoviesData()
        default:
            break
        }
    }

    // MARK: Private Methods

    private func setView() {
        view.addSubview(tableView)
        view.addSubview(popularButton)
        view.addSubview(topRatingsButton)
        view.addSubview(latestButton)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .black
        title = ButtonsTitle.emptyText
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        constraintsTableView()
        setButtons()
        loadPopularMoviesData()
    }

    private func constraintsTableView() {
        tableView.topAnchor.constraint(equalTo: popularButton.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setButtons() {
        popularButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        popularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        popularButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        popularButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        topRatingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        topRatingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topRatingsButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        topRatingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        latestButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        latestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        latestButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        latestButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func loadPopularMoviesData() {
        viewModel.fetchPopularMoviesData { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellId.id,
            for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }

        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValues(movie)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = SecondViewController()
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        guard let movieDate = movie.date else { return }
        secondVC.dateLabel.text = ButtonsTitle.date + "\(movieDate)"
        secondVC.overviewLabel.text = movie.overview
        secondVC.movieId = movie.id
        secondVC.title = movie.title
        secondVC.setUI(actorImage: movie.backdropImage)
        navigationController?.pushViewController(secondVC, animated: true)
    }
}
