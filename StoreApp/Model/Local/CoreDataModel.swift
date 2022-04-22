//
//  Goods+CoreDataProperties.swift
//
//
//  Created by Станислав Зверьков on 22.04.2022.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import UIKit

@objc(Goods)
public class Goods: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goods> {
        return NSFetchRequest<Goods>(entityName: "Goods")
    }

    @NSManaged public var image: [UIImage]
    @NSManaged public var name: String
    @NSManaged public var price: Int64

}

extension Goods : Identifiable {

}


import Foundation
import CoreData

