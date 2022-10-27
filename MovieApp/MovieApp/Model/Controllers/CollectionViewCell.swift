// CollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// vc
class CollectionViewCell: UICollectionViewCell {
    let photoOfActor: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameOfActor: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 13, weight: .semibold)
        return name
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(photoOfActor)
        addSubview(nameOfActor)
        backgroundColor = .green
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

    func setCellWithValues(_ actor: ActorInfo) {
        setUI(actorImage: actor.actorImage, actorName: actor.name)
    }

    private func setUI(actorImage: String?, actorName: String?) {
        nameOfActor.text = actorName
        guard let imageString = actorImage else { return }

        let urlString = "https://image.tmdb.org/t/p/w500" + imageString

        guard let imageURL = URL(string: urlString) else { return }

        photoOfActor.image = nil
        print(urlString)
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
                    self.photoOfActor.image = image
                }
            }
        }.resume()
    }
}
