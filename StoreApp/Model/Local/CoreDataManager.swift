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
    
    func saveChanges(){
        do{
            try context.save()
        } catch {
            print("Saving error")
        }
    }
    
    func addToCorData(name: String, price: Int, images: [UIImage]) {
        let product = Goods(context: context)
        product.name = name
        product.price = Int64(price)
        product.image = images
    }
    
}
