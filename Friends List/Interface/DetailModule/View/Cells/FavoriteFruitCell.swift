//
//  FavoriteFruitCell.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

class FavoriteFruitCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite Fruit"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Simple description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fruitImageView: UIImageView = {
        let view = UIImageView()
        let defImage = UIImage(named: "banana")!
        view.image = defImage
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private func setupViews() {
        backgroundColor = .white
        separatorInset = .zero
        addSubview(titleLabel)
        addSubview(fruitImageView)
        setupConstarints()
    }
    
    private func setupConstarints() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        fruitImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        fruitImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        fruitImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        fruitImageView.heightAnchor.constraint(equalTo: fruitImageView.widthAnchor).isActive = true
        fruitImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    func configurateCell(favoriteFruit: FavoriteFruit) {
        var image: UIImage {
            switch favoriteFruit {
            case .apple: return UIImage(named: "apple")!
            case .banana: return UIImage(named: "banana")!
            case .strawberry: return UIImage(named: "strawberry")!
            }
        }
        self.fruitImageView.image = image
    }
}
