//
//  FriendsListRouter.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation
import MessageUI
import SafariServices

protocol DetailRouterProtocol: class {
    func showDetailViewController(friend: IFriend?, service: IFriendsService?)
    func showMailView(email: String)
    func makeCall(number: String)
    func openCoordinateInMap(latitude: Double?, longitude: Double?)
}

class DetailRouter {
    weak var detailViewController: BaseViewController?
    init(view: DetailViewController) {
        self.detailViewController = view
    }
}

extension DetailRouter: DetailRouterProtocol {
    func showDetailViewController(friend: IFriend?, service: IFriendsService?) {
        let detailViewController = DetailBuilder.build(friend: friend, service: service)
        self.detailViewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func showMailView(email: String) {
        let mailComposeViewController = configureMailController(email: email)
        if MFMailComposeViewController.canSendMail() {
            detailViewController?.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            detailViewController?.showAlert(title: "Could not send email", message: "Your device could not send email")
        }
    }
    
    func makeCall(number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openCoordinateInMap(latitude: Double?, longitude: Double?) {
        guard let lat = latitude, let lon = longitude, let yandexmapsAppUrl = URL(string: "yandexmaps://maps.yandex.ru/?pt=\(lon),\(lat)&z=18&l=map") else {
            showMapAlert()
            return
        }
        if UIApplication.shared.canOpenURL(yandexmapsAppUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(yandexmapsAppUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(yandexmapsAppUrl)
            }
        } else {
            guard let googlemapsAppUrl = URL(string: "comgooglemaps://?q=Power&center=\(lon),\(lat)&zoom=14&views=traffic") else {
                showMapAlert()
                return
            }
            if UIApplication.shared.canOpenURL(googlemapsAppUrl) {
                if #available(iOS 10.0, *)  {
                    UIApplication.shared.open(googlemapsAppUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googlemapsAppUrl)
                }
            } else {
                let vc = SFSafariViewController(url: URL(string: "https://yandex.ru/maps/?pt=\(lon),\(lat)&z=18&l=map")!)
                detailViewController?.present(vc, animated: true)
            }
        }
    }
    
    private func showMapAlert() {
        detailViewController?.showAlert(title: "Could not open map", message: nil)
    }
    
    private func configureMailController(email: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        if let view = detailViewController as? DetailViewController{
            mailComposerVC.mailComposeDelegate = view
        }
        mailComposerVC.setToRecipients([email])
        return mailComposerVC
    }
}
