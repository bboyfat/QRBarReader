//
//  CoreDataManager.swift
//  QRBarReader
//
//  Created by Andrey Petrovskiy on 4/1/19.
//  Copyright © 2019 Andrey Petrovskiy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    
   static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QRBarReader")
        container.loadPersistentStores(completionHandler: { (StoreDescription, handleError) in
            if let error = handleError{
                fatalError("Unnable to load persistentStrore")
            }
        })
        return container
    }()
}
