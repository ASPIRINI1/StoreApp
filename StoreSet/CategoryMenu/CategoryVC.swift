//
//  CategoryVC.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 03.04.2022.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireAPI = APIManager()
    let cat = ["1","2","3","4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.delegate = self
//        tableView.dataSource = self
    }
    

}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.label.text = cat[indexPath.row]
        
        return cell
    }
    
    
}
