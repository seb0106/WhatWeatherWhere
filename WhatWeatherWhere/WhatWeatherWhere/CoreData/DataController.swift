//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import CoreData

class DataController{
    
    static let shared = DataController(modelName: "WhatWeatherWhere")
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    func configureContext() {
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name:modelName)
        
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func load(completion: (()-> Void)? = nil) {
        persistentContainer.loadPersistentStores{
            storeDescription, error in
            guard error == nil else{
                fatalError(error?.localizedDescription as! String)
            }
            
            self.autoSaveViewContext()
            self.configureContext()
            
            completion?()
        }
    }
}
extension DataController {
    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving")
        
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
