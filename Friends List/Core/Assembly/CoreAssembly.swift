//
//  CoreAssembly.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 20/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: ICoreDataStack { get }
}

class CoreAssembly: ICoreAssembly {
    
    lazy var coreDataStack: ICoreDataStack = CoreDataStack()
}
