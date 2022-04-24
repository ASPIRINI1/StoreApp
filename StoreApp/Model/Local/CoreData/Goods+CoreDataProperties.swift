//
//  Goods+CoreDataProperties.swift
//  
//
//  Created by Станислав Зверьков on 24.04.2022.
//
//

import Foundation
import CoreData
import UIKit

extension Goods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goods> {
        return NSFetchRequest<Goods>(entityName: "Goods")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: UIImage?
    @NSManaged public var name: String?
    @NSManaged public var price: Int64

}
