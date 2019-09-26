//
//  InterfaceAssembly.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol IInterfaceAssembly {
    var serviceAssembly: IServiceAssembly { get }
    func getFriendsService() -> IFriendsService
}

class InterfaceAssembly: IInterfaceAssembly {
    
    var serviceAssembly: IServiceAssembly
    
    init(servicesAssembly: IServiceAssembly) {
        self.serviceAssembly = servicesAssembly
    }
    
    func getFriendsService() -> IFriendsService {
        return serviceAssembly.friendsService
    }
}
