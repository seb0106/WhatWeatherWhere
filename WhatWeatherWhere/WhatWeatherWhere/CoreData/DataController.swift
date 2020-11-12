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
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name:modelName)
    }
}
