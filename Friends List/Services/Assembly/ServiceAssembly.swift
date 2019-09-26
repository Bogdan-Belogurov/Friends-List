//
//  ServiceAssembly.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol IServiceAssembly: class {
    var networkManager: INetworkManager { get }
    var friendsService: IFriendsService { get }
}

class ServiceAssembly: IServiceAssembly {
    
    var coreAssembly: ICoreAssembly

    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var networkManager: INetworkManager = NetworkManager()
    lazy var friendsService: IFriendsService = FriendsService(networkManager: networkManager, coreDataStack: coreAssembly.coreDataStack)
}
