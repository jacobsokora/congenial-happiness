//
//  Entry+CoreDataProperties.swift
//  Travelogue
//
//  Created by Jacob Sokora on 7/19/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension Entry {

    var date: Date {
        get {
            return rawDate as Date
        }
        set {
            rawDate = newValue as NSDate
        }
    }
    
    var image: UIImage? {
        get {
            guard let data = rawImage as Data? else {
                return nil
            }
            return UIImage(data: data)
        }
        set {
            guard let newValue = newValue else {
                return
            }
            rawImage = UIImagePNGRepresentation(newValue) as NSData?
        }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var title: String
    @NSManaged public var rawDate: NSDate
    @NSManaged public var content: String
    @NSManaged public var trip: Trip
    @NSManaged public var rawImage: NSData?

}
