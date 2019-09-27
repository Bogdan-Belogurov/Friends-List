//
//  FriendsCell.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Simple name"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Simple email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var isActive: Bool = false
    
    private lazy var activeView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(nameLabel)
        addSubview(emailLabel)
        addSubview(activeView)
        setupConstarints()
    }
    
    private func setupConstarints() {
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: activeView.leadingAnchor, constant: -8).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

        activeView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        activeView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        activeView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        activeView.widthAnchor.constraint(equalTo: activeView.heightAnchor, constant: 0).isActive = true
    }
    
    func setupCell(name: String?, email: String?, isActive: Bool) {
        self.nameLabel.text = name
        self.emailLabel.text = email
        self.isActive = isActive
        self.activeView.backgroundColor = isActive ? .green: .gray
    }
}
