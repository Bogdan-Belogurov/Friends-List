//
//  DetailCell.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layer.cornerRadius = 8
        layer.addShadow(location: .center)
    }
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "Simple tag"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(tagLabel)
        setupConstarints()
    }
    
    private func setupConstarints() {
        tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    func configureWithTag(tag: String) {
        self.tagLabel.text = "#" + tag
    }
}
