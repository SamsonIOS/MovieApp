// SecondViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран с подробной информацией о фильме
final class SecondViewController: UIViewController {
    // MARK: Constants

    private enum Constants {
        static let imageUrl = "https://image.tmdb.org/t/p/w500"
        static let collectionCellId = "CollectionCell"
        static let responseText = "Response"
        static let dontGetDataText = "Данные не получены"
        static let buttonTitle = "К Списку"
        static let dataTaskErrorText = "DataTask error:"
    }

    // MARK: Private properties

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 170, height: 230)
        layout.minimumLineSpacing = 18
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionCellId)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .black
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.orange.cgColor
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    private let overviewLabel: UITextView = {
        let label = UITextView()
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .black
        label.textContainer.maximumNumberOfLines = 0
        label.isEditable = false
        label.isSelectable = false
        label.textContainer.lineBreakMode = .byCharWrapping
        return label
    }()

    private var actor = Actors()

    var movieId: Int?

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    // MARK: Public Methods

    func setUI(movie: Movies, imageUrl: String) {
        dateLabel.text = movie.date
        overviewLabel.text = movie.overview
        movieId = movie.id
        title = movie.title
        let urlString = "\(Constants.imageUrl)\(imageUrl)"
        guard let imageURL = URL(string: urlString) else { return }
        movieImageView.image = nil
        getImageData(url: imageURL)
    }

    // MARK: Private Methods

    private func setView() {
        view.backgroundColor = .black
        view.addSubview(movieImageView)
        view.addSubview(dateLabel)
        view.addSubview(overviewLabel)
        view.addSubview(collectionView)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationController?.navigationBar.topItem?.title = Constants.buttonTitle
        collectionView.backgroundColor = .black
        setConstraints()
        loadPopularMovie()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 250),

            dateLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            overviewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overviewLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 30),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            overviewLabel.heightAnchor.constraint(equalToConstant: 190),

            collectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 7),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }

    private func loadPopularMovie() {
        actor.fetchActorData(idMovie: movieId) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    private func getImageData(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("\(Constants.dataTaskErrorText) \(error.localizedDescription)")
                return
            }

            guard response != nil else {
                print(Constants.responseText)
                return
            }

            guard let data = data else {
                print(Constants.dontGetDataText)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.movieImageView.image = image
                }
            }
        }.resume()
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actor.numberOfRowsInSection(section: section)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: Constants.collectionCellId,
                for: indexPath
            ) as? ActorCollectionViewCell
        else { return UICollectionViewCell() }
        let actor = actor.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValues(actor)
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        return cell
    }
}
