//
//  Quote+CoreDataProperties.swift
//  
//
//  Created by Cameron Bardell on 2019-12-31.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var author: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var text: String?
    @NSManaged public var title: String?

}
