//
//  CoreData.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 27.03.2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var model = [Goods]()
    
    init() {
        getAllItems()
    }
    
    func getAllItems(){
        do{
            model = try context.fetch(Goods.fetchRequest())
        } catch {
            print("Getting error")
        }
    }
    
}
