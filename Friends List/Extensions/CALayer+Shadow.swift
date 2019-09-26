//
//  CALayer+Shadow.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 25/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

enum ShadowLocation: String {
    case bottom
    case top
    case center
}

extension CALayer {
    func addShadow(location: ShadowLocation, color: UIColor = .lightGray, opacity: Float = 0.3, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        case .center:
            addShadow(offset: CGSize(width: 0, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }
    
    private func addShadow(offset: CGSize, color: UIColor = .lightGray, opacity: Float = 0.2, radius: CGFloat = 5.0) {
        self.masksToBounds = false
        self.shadowColor = color.cgColor
        self.shadowOffset = offset
        self.shadowOpacity = opacity
        self.shadowRadius = radius
    }
}
