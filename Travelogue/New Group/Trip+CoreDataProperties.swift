//
//  Trip+CoreDataProperties.swift
//  Travelogue
//
//  Created by Jacob Sokora on 7/19/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {
    
    var startDate: Date {
        get {
            return rawStartDate as Date
        }
    }
    
    var endDate: Date? {
        get {
            return (entries.allObjects as! [Entry]).sorted{
                $0.date > $1.date
            }.first?.date ?? nil
        }
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var name: String
    @NSManaged public var rawStartDate: NSDate
    @NSManaged public var entries: NSSet

}

// MARK: Generated accessors for entries
extension Trip {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}
