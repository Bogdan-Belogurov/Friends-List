//
//  FriendsService.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

class FriendsService: IFriendsService {
    
    var networkManager: INetworkManager
    var coreDataStack: ICoreDataStack

    
    init(networkManager: INetworkManager, coreDataStack: ICoreDataStack) {
        self.networkManager = networkManager
        self.coreDataStack = coreDataStack
    }
    
    func friends() -> [IFriend]? {
        guard Thread.current.isMainThread else {
            return nil
        }
        let context = self.coreDataStack.mainContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let savedEntities = self.coreDataStack.findAll(Friend.self, in: context, predicate: nil, sortDescriptor: [sortDescriptor])
        return savedEntities
    }
    
    func friend(with id: Int16) -> IFriend? {
        guard Thread.current.isMainThread else {
            return nil
        }
        let context = self.coreDataStack.mainContext
        let predicate = Friend.fetchFriendPredicate(with: id)
        let savedEntities = self.coreDataStack.findAll(Friend.self, in: context, predicate: predicate, sortDescriptor: nil)
        return savedEntities.first
    }
    
    func getFriends(completion: @escaping(Result<[IFriend]?, ApiError>) -> Void) {
        networkManager.getFriends { result in
            switch result {
                
            case .success(let friends):
                guard !Friend.insertFriends(friends, in: self.coreDataStack.saveContext).isEmpty else { return }

                self.coreDataStack.performSave(in: self.coreDataStack.saveContext) { error in
                    if let error = error {
                        let coreDataSavingError = ApiError(error: "coredata-saving-error", message: error.localizedDescription)
                        DispatchQueue.main.async {
                            completion(.failure(coreDataSavingError))
                        }
                        return
                    }
                
                    DispatchQueue.main.async {
                        completion(.success(self.friends()))
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteAllFriendsCashe() {
        let context = self.coreDataStack.mainContext
        _ = self.coreDataStack.delete(Friend.self, in: context, with: nil)
    }
}
