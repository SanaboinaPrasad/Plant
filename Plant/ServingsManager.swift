//
//  DailyServing.swift
//  Plant
//
//  Created by Olivia Brown on 9/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ServingsManager {

    var servingsHistory = [DailyServing]()
    private var managedContext: NSManagedObjectContext? = nil
    private var appDelegate: AppDelegate? = nil

    func save(numServings: Int16, for servingType: String) {
        guard let serving = servingsHistory.last else { return }
        serving.setValue(numServings, forKey: servingType)

        do {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            managedContext = appDelegate?.persistentContainer.viewContext
            try managedContext?.save()
        } catch let error as NSError {
            print("Failed to save with error: \(error), \(error.userInfo)")
        }
    }

    private func catchUpToCurrentDate() {
        let previous = servingsHistory.last?.value(forKey: "date") as? Date
        guard let prevDay = previous else {
            addNewDailyServing()
            return
        }
        if !Calendar.current.isDate(prevDay, inSameDayAs:Date()) {
            addNewDailyServing()
        }
    }

    func fetchToday() -> DailyServing? {
        catchUpToCurrentDate()
        let request: NSFetchRequest<DailyServing> = DailyServing.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        print(servingsHistory)

        do {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            guard let managedContext = appDelegate?.persistentContainer.viewContext else { return nil }
            try servingsHistory = managedContext.fetch(request)
            return servingsHistory.last
        } catch {
            print("Could not load data")
            return nil
        }
    }

    private func addNewDailyServing() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let serving = DailyServing(context: managedContext)
        serving.setValue(0, forKey: "leafyVegetables")
        serving.setValue(0, forKey: "otherVegetables")
        serving.setValue(0, forKey: "berries")
        serving.setValue(0, forKey: "otherFruit")
        serving.setValue(0, forKey: "wholeGrains")
        serving.setValue(0, forKey: "legumes")
        serving.setValue(0, forKey: "nutsAndSeeds")
        serving.setValue(Date(), forKey: "date")
        servingsHistory.append(serving)
    }
    
}
