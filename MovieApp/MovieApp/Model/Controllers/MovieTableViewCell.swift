// MovieTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомная ячейка table view
final class MovieTableViewCell: UITableViewCell {
    // MARK: Constants

    private enum Constants {
        static let urlImage = "https://image.tmdb.org/t/p/w500"
        static let initErrorText = "init(coder:) has not been implemented"
    }

    // MARK: Public Properties

    private let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameFilmLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let infoFilmLabel: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .black
        return label
    }()

    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.initErrorText)
    }

    // MARK: Public Methods

    func setCellWithValues(_ movie: Movies) {
        nameFilmLabel.text = movie.title

        infoFilmLabel.text = movie.overview

        guard let rating = movie.rating else { return }
        ratingLabel.text = String(rating)

        guard let imageString = movie.movieImage else { return }
        let urlString = Constants.urlImage + imageString

        guard let imageURL = URL(string: urlString) else {
            return
        }

        getImageData(url: imageURL)
    }

    // MARK: Private Method

    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            filmImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            filmImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            filmImageView.heightAnchor.constraint(equalToConstant: 210),
            filmImageView.widthAnchor.constraint(equalToConstant: 160),

            nameFilmLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            nameFilmLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 10),
            nameFilmLabel.widthAnchor.constraint(equalToConstant: 210),
            nameFilmLabel.heightAnchor.constraint(equalToConstant: 60),

            infoFilmLabel.topAnchor.constraint(equalTo: nameFilmLabel.bottomAnchor, constant: 5),
            infoFilmLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 10),
            infoFilmLabel.widthAnchor.constraint(equalToConstant: 170),
            infoFilmLabel.heightAnchor.constraint(equalToConstant: 150),

            ratingView.leadingAnchor.constraint(equalTo: filmImageView.leadingAnchor),
            ratingView.topAnchor.constraint(equalTo: filmImageView.topAnchor, constant: 0),
            ratingView.widthAnchor.constraint(equalToConstant: 24),
            ratingView.heightAnchor.constraint(equalToConstant: 24),

            ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor)
        ])
    }

    private func setupView() {
        backgroundColor = .black
        addSubview(filmImageView)
        addSubview(nameFilmLabel)
        addSubview(infoFilmLabel)
        addSubview(ratingView)
        addSubview(ratingLabel)
    }

    private func getImageData(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.filmImageView.image = image
                }
            }
        }.resume()
    }
}
