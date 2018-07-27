//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Jacob Sokora on 7/19/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Trip)
public class Trip: NSManagedObject {
    
    convenience init?(name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.init(entity: Trip.entity(), insertInto: context)
        self.name = name
        self.rawStartDate = NSDate()
        self.entries = NSSet()
    }
}
