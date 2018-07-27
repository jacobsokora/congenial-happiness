//
//  Entry+CoreDataClass.swift
//  Travelogue
//
//  Created by Jacob Sokora on 7/19/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Entry)
public class Entry: NSManagedObject {
    
    convenience init?(title: String, content: String, date: Date, trip: Trip) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.init(entity: Entry.entity(), insertInto: context)
        self.title = title
        self.content = content
        self.date = date
        self.trip = trip
    }
}
