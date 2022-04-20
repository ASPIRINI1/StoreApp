//
//  StoreCollectionViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import UIKit

class StoreCollectionViewController: UICollectionViewController {
    
    let fireAPI = APIManager()
    var products: [Document] = []
    
//    CategoryMenu variables
    let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryTVC") as! CategoryTableViewController
    
//     variable for opening detaleVC
    var selectedIndex = (-1,-1)
    
//     searchBar variables
    private let searchController = UISearchController(searchResultsController: nil)
    private var filtredProducts: [Document] = []
    
    private var searchBarIsEmpty: Bool{
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFiltering: Bool{
        return searchController.isActive && !searchBarIsEmpty
    }
    
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        notificationsSetUp()
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        fireAPI.getProductsForCategory(category: "keyboards", subCategories: "keyboards")
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("DocsLoaded"), object: nil, queue: nil) { _ in
//            self.products = self.fireAPI.getAllDocs()
//            print(self.products.count)
//            print(self.products.first)
//            self.collectionView.reloadData()
//        }
        
        //MARK: setUP searchController
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        products.removeAll()
        for i in 0...10{
            products.append(Document(documentID: "prod"+"\(i)", name:  "product"+"\(i)", price: 100+i, img: "11", description:  "description of product: "+"\(i)"))
        }
        fireAPI.docs.removeAll()
        fireAPI.docs = products
        self.collectionView.reloadData()
        
    }
    
//    MARK: - CategoryButton

    @IBAction func CategoryButton(_ sender: Any) {
        
        func showMenu(){
            UIView.animate(withDuration: 0.3){
                
                self.categoryVC.view.frame = CGRect(x: 0,
                                                    y: self.view.safeAreaLayoutGuide.layoutFrame.minY,
                                                    width: UIScreen.main.bounds.size.width/1.5,
                                                    height: self.categoryVC.view.frame.height)
                
                self.view.addSubview(self.categoryVC.view)
                AppDelegate.isCategoryVC = false
            }

        }

        func hideMenu(){
            
            UIView.animate(withDuration: 0.3, animations: {
                self.categoryVC.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                
            }) { (finished) in
                self.categoryVC.view.removeFromSuperview()
                AppDelegate.isCategoryVC = true
            }
        }
        
            if AppDelegate.isCategoryVC{
            showMenu()
        } else {
            hideMenu()
        }
    }
    

    
//    MARK: - Seque
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
        let detailVC = DetailViewController()
        detailVC.docID = products[selectedIndex.1].documentID
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
//    MARK: - Notifications
    private func notificationsSetUp() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 10.0, height: 10.0))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LoadingNotes"), object: nil, queue: nil) { _ in
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("NotesLoaded"), object: nil, queue: nil) { _ in
//            self.notes = self.FireAPI.getAllNotes()
//            self.notesTableView.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }


// MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filtredProducts.count
        }
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCell", for: indexPath) as! StoreCollectionViewCell
    
        if isFiltering {
            cell.name.text = filtredProducts[indexPath.row].name
            cell.price.text = "\(filtredProducts[indexPath.row].price)"
            cell.image.image = UIImage(named: "11")
        } else {
            cell.name.text = products[indexPath.row].name
            cell.price.text = "\(products[indexPath.row].price)"
            cell.image.image = UIImage(named: "11")
        }
        

    
        return cell
    }
    
//    MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex.0 = indexPath.section
        selectedIndex.1 = indexPath.row
    }
    
}

//MARK: - UISearchResultsUpdating, UISearchControllerDelegate

extension StoreCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String){
        filtredProducts = products.filter({ document in
            return document.name.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
}
