// SecondViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран с подробной информацией о фильме
final class SecondViewController: UIViewController {
    // MARK: Private properties

    private var actorModel = ActorMovie()

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
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .green
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        // label.backgroundColor = .
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }()

    let overviewLabel: UITextView = {
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

    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(movieImageView)
        view.addSubview(nameLabel)
        view.addSubview(overviewLabel)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        setConstraints()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationController?.navigationBar.topItem?.title = "К Фильмам"
        loadPopularMoviesData()
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 250),

            nameLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            overviewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overviewLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 30),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            overviewLabel.heightAnchor.constraint(equalToConstant: 230),

            collectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 7),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    private func loadPopularMoviesData() {
        actorModel.fetchActorData(idMovie: movieId) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    func setUI(actorImage: String?) {
        guard let imageString = actorImage else { return }

        let urlString = "https://image.tmdb.org/t/p/w500" + imageString

        guard let imageURL = URL(string: urlString) else { return }

        movieImageView.image = nil
        getImageData(url: imageURL)
    }

    private func getImageData(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }

            guard response != nil else {
                print("Response")
                return
            }

            guard let data = data else {
                print("Данные не получены")
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

extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actorModel.numberOfRowsInSection(section: section)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        else { return UICollectionViewCell() }
        let actor = actorModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValues(actor)
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        return cell
    }
}
