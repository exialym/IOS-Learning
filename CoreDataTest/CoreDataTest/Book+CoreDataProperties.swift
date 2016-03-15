//
//  Book+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by 🦁️ on 15/12/26.
//  Copyright © 2015年 exialym. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Book {

    @NSManaged var name: String?
    @NSManaged var author: String?

}
