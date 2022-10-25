// ViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class ViewController: UIViewController {
    private var viewModel = MovieViewModel()

    private lazy var popularButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle("Популярные", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.tag = 0
        return button
    }()

    private lazy var topRatingsButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle("Топ рейтинга", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.tag = 1
        return button
    }()

    private lazy var latestButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle("Новинки", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.tag = 2
        return button
    }()

    // MARK: Private properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FirstTableViewCell.self, forCellReuseIdentifier: "firstCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.backgroundColor = .black
        view.addSubview(popularButton)
        view.addSubview(topRatingsButton)
        view.addSubview(latestButton)
        constraintsTableView()
        setButtons()
        loadPopularMoviesData()
        popularButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        topRatingsButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        latestButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
    }

    private func constraintsTableView() {
        tableView.topAnchor.constraint(equalTo: popularButton.bottomAnchor, constant: 20).isActive = true
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

    @objc private func action(sender: UIButton) {
        print("fdf")
        switch sender.tag {
        case 0:
            let url =
                "https://api.themoviedb.org/3/movie/popular?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US&page=1"
            viewModel.filmUrl = url
            loadPopularMoviesData()
        case 1:
            let url =
                "https://api.themoviedb.org/3/movie/top_rated?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US&page=1"
            viewModel.filmUrl = url
            loadPopularMoviesData()
        case 2:
            let url =
                "https://api.themoviedb.org/3/movie/upcoming?api_key=74b256bd9644791fa138aeb51482b3b8&language=en-US&page=1"
            viewModel.filmUrl = url
            loadPopularMoviesData()
        default:
            break
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "firstCell",
            for: indexPath
        ) as? FirstTableViewCell else { return UITableViewCell() }

        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValues(movie)
        cell.selectionStyle = .none

        return cell
    }
}
