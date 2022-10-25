// SegmentTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

// vc
// class SegmentTableViewCell: UITableViewCell {
//    private var category = ["Популярные", "Топ рейтинга"]
//    private var segmentControl = UISegmentedControl()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupView()
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupView() {
//        addSubview(segmentControl)
//        backgroundColor = .white
//        segmentControl = UISegmentedControl(items: category)
//        NSLayoutConstraint.activate([
//            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            segmentControl.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            segmentControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//            segmentControl.heightAnchor.constraint(equalToConstant: 50),
//            segmentControl.widthAnchor.constraint(equalToConstant: 150)
//        ])
//    }
// }
