//
//  Persons.swift
//  Contacts App
//
//  Created by The Guest Family on 7/27/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

import Foundation
import CoreData

@objc(Person)
class Person: NSManagedObject {
    
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var dateOfBirth: String
    @NSManaged var phoneNumber: String
    @NSManaged var zipCode: String
    
}
