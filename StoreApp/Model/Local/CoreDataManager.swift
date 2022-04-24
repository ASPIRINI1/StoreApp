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
    
    func getAllItems() -> [Goods] {
        do{
            model = try context.fetch(Goods.fetchRequest())
            return model
        } catch {
            print("Getting error")
        }
        return []
    }
    
    func saveChanges(){
        do{
            try context.save()
        } catch {
            print("Saving to CoreData error")
        }
    }
    
    func addToCorData(id: String, name: String, price: Int, category: String, subCategory: String?, image: UIImage) {
        
        let product = Goods(context: context)
        product.category = category
        product.subCategory = subCategory
        product.id = id
        product.name = name
        product.price = Int64(price)
        product.image = image
        saveChanges()
    }
    
//    func getProductForID(Id: String) {
//        do {
//            model = try context.existingObject(with: id)
//            
//        } catch {
//            print("Error getting product from CoreData")
//        }
//    }
    
    func getImage() -> UIImage{
        
        var image = UIImage()
        for img in model {
            image = img.image!
        }
        return image
    }
    
}
