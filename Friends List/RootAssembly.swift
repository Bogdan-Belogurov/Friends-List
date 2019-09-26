//
//  RootAssembly.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IInterfaceAssembly = InterfaceAssembly(servicesAssembly: self.servicesAssembly)
    private lazy var servicesAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
