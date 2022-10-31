// ActorCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомная ячейка коллекции
final class ActorCollectionViewCell: UICollectionViewCell {
    // MARK: Constants

    private enum Constants {
        static let urlImage = "https://image.tmdb.org/t/p/w500"
        static let dataTaskErrorText = "DataTask error: "
        static let responseText = "Response"
        static let dontGetDataText = "Данные не получены"
        static let initErrorText = "init(coder:) has not been implemented"
    }

    // MARK: Private Visual Components

    let actorPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let actorNameLabel: UILabel = {
        let name = UILabel()
        name.textColor = .white
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 13, weight: .semibold)
        return name
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.initErrorText)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }

    // MARK: Public Methods

    func setCellWithValues(_ actor: ActorInfo) {
        setUI(actorImage: actor.actorImage, actorName: actor.name)
    }

    // MARK: Private Methods

    private func setupViews() {
        addSubview(actorPhotoImageView)
        addSubview(actorNameLabel)
        backgroundColor = .black
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            actorNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            actorNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            actorNameLabel.bottomAnchor.constraint(equalTo: actorPhotoImageView.topAnchor, constant: 2),

            actorPhotoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            actorPhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            actorPhotoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            actorPhotoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    private func setUI(actorImage: String?, actorName: String?) {
        actorNameLabel.text = actorName
        guard let imageString = actorImage else { return }

        let urlString = Constants.urlImage + imageString

        guard let imageURL = URL(string: urlString) else { return }

        actorPhotoImageView.image = nil
        getImageData(url: imageURL)
    }

    private func getImageData(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("\(Constants.dataTaskErrorText) \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print(Constants.dontGetDataText)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.actorPhotoImageView.image = image
                }
            }
        }.resume()
    }
}
