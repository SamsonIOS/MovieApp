// CollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомная ячейка коллекции
final class CollectionViewCell: UICollectionViewCell {
    // MARK: Constants

    private enum Constants {
        static let urlImage = "https://image.tmdb.org/t/p/w500"
        static let dataTaskError = "DataTask error: "
        static let response = "Response"
        static let dontGetData = "Данные не получены"
    }

    // MARK: Public properties

    private let photoOfActor: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameOfActor: UILabel = {
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
        fatalError("init(coder:) has not been implemented")
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
        addSubview(photoOfActor)
        addSubview(nameOfActor)
        backgroundColor = .black
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameOfActor.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameOfActor.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            nameOfActor.bottomAnchor.constraint(equalTo: photoOfActor.topAnchor, constant: 2),

            photoOfActor.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            photoOfActor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            photoOfActor.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            photoOfActor.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    private func setUI(actorImage: String?, actorName: String?) {
        nameOfActor.text = actorName
        guard let imageString = actorImage else { return }

        let urlString = Constants.urlImage + imageString

        guard let imageURL = URL(string: urlString) else { return }

        photoOfActor.image = nil
        print(urlString)
        getImageData(url: imageURL)
    }

    private func getImageData(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(Constants.dataTaskError + "\(error.localizedDescription)")
                return
            }

            guard response != nil else {
                print(Constants.response)
                return
            }

            guard let data = data else {
                print(Constants.dontGetData)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.photoOfActor.image = image
                }
            }
        }.resume()
    }
}
