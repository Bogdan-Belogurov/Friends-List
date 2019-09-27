//
//  FriendsCell.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

protocol TagsViewProtocol: class {
    func updateViewWithTags(tags: [String]?)
}

class TagsCell: UITableViewCell {
    fileprivate let cellId = "tagCellId"
    var presenter: TagsPresenterProtocol?
    var tags: [String]?
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 175, height: 150)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tags:"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupViews()
        TagsBuilder.build(tagsCollectionViewCell: self)
    }
    
    private var isActive: Bool = false
    
    private func setupViews() {
        backgroundColor = .clear
        addSubview(collectionView)
        addSubview(titleLabel)
        setupConstarints()
    }
    
    private func setupConstarints() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

extension TagsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? TagCell else {return UICollectionViewCell()}
        guard let tag = self.tags?[indexPath.row] else { return cell }
        cell.configureWithTag(tag: tag)
        return cell
    }
}

extension TagsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
}

extension TagsCell: TagsViewProtocol {
    func updateViewWithTags(tags: [String]?) {
        self.tags = tags
        collectionView.reloadData()
    }
}
