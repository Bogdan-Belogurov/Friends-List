//
//  EyeColorCell.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 25/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

class EyeColorCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Eye Color"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let eyeColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 8
        return view
    }()
    
    private func setupViews() {
        backgroundColor = .white
        separatorInset = .zero
        addSubview(titleLabel)
        addSubview(eyeColorView)
        setupConstarints()
    }
    
    private func setupConstarints() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: eyeColorView.leadingAnchor, constant: -16).isActive = true
        eyeColorView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        eyeColorView.heightAnchor.constraint(equalTo: eyeColorView.widthAnchor).isActive = true
        eyeColorView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0).isActive = true
    }
    
    func configurateCell(eyeColor: EyeColor) {
        var color: UIColor {
            switch eyeColor {
            case .blue: return .blue
            case .brown: return .brown
            case .green: return .green
            }
        }
        self.eyeColorView.backgroundColor = color
    }
}

