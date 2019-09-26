//
//  FriendsListInteractor.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol FriendsListInteractorProtocol: class {
    var friendService: IFriendsService? { get set }
    func friends() -> [IFriend]?
    func loadFriends(completion: @escaping(Result<[IFriend]?, ApiError>) -> Void)
    func deleteAllFriendsCashe()
}

class FriendsListInteractor {
    var friendService: IFriendsService?
    var timer: Timer?
    fileprivate let fireTimeKey = "fireTimeKey"
    init(service: IFriendsService) {
        self.friendService = service
        createTimer()
    }
    
    private func setDataLifetime(lifetime: Double) {
        let fireTime = Date().addingTimeInterval(lifetime)
        UserDefaults.standard.set(fireTime, forKey: fireTimeKey)
        createTimer()
    }
    
    private func createTimer() {
        if timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: 60,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
        }
        updateTimer()
    }
    
    @objc func updateTimer() {
        guard let fireTime = UserDefaults.standard.object(forKey: fireTimeKey) as? Date else { return }
        if Date() >= fireTime  {
            deleteAllFriendsCashe()
            cancelTimer()
        }
    }
    
    private func cancelTimer() {
      timer?.invalidate()
      timer = nil
    }
}

extension FriendsListInteractor: FriendsListInteractorProtocol {
    func friends() -> [IFriend]? {
        return friendService?.friends()
    }
    
    func loadFriends(completion: @escaping (Result<[IFriend]?, ApiError>) -> Void) {
        friendService?.getFriends(completion: { [weak self] result in
            switch result {
            case .success:
                completion(result)
                self?.setDataLifetime(lifetime: 300)
            case .failure:
                completion(result)
            }
        })
    }
    
    func deleteAllFriendsCashe() {
        friendService?.deleteAllFriendsCashe()
    }
}
