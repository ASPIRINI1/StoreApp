//
//  StoreCollectionViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import UIKit

protocol ConfigureStoreCVCDelegate: class {
    func setProducts(category: String, subCategory: String)
}

class StoreCollectionViewController: UICollectionViewController, ConfigureStoreCVCDelegate {
    
    
    
    private var products: [Document] = []
    private var prodImages: [UIImage] = []
    
//    CategoryMenu variables
    private let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryTVC") as! CategoryTableViewController
    
//     variable for opening detaleVC
    private var selectedIndex = (-1,-1)
    
//     searchBar variables
    private let searchController = UISearchController(searchResultsController: nil)
    private var filtredProducts: [Document] = []
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        notificationsSetUp()
        
        categoryVC.storeDelegate = self
        
        //MARK: Setup searchController
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        navigationItem.searchController = searchController
        definesPresentationContext = true

        
        FireAPI.shared.getRandomProducts(count: 10) { docs in
            self.products = docs
            self.collectionView.reloadData()
            
            for doc in docs {
                FireAPI.shared.getFirstImage(document: doc, completion:{ image in
                    doc.image = image
                    self.collectionView.reloadData()
                })
            }
        }
        
    }
    
//    MARK: - CategoryButton

    @IBAction func CategoryButton(_ sender: Any) {
        
        if AppDelegate.isCategoryVC {
            showMenu()
        } else {
            hideMenu()
        }
    }
    
    func showMenu() {
        
        self.view.addSubview(self.categoryVC.view)
        
        UIView.animate(withDuration: 0.3){
            
            self.categoryVC.view.frame = CGRect(x: 0,
                                                y: (self.navigationController?.navigationBar.frame.height)!,
                                                width: UIScreen.main.bounds.size.width/1.5,
                                                height: self.categoryVC.view.frame.height)
            
            AppDelegate.isCategoryVC = false
        }

    }

    func hideMenu() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.categoryVC.view.frame = CGRect(x: -UIScreen.main.bounds.size.width,
                                                y: (self.navigationController?.navigationBar.frame.height)!,
                                                width: UIScreen.main.bounds.size.width,
                                                height: UIScreen.main.bounds.size.height)
            
        }) { (finished) in
            self.categoryVC.view.removeFromSuperview()
            AppDelegate.isCategoryVC = true
        }
    }

    
//    MARK: - Seque
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        detailVC.setDocument(docoment: products[selectedIndex.1])
    }
    
//    MARK: - Notifications
    
    private func notificationsSetUp() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 10.0, height: 10.0))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LoadingNotes"), object: nil, queue: nil) { _ in
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("NotesLoaded"), object: nil, queue: nil) { _ in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
//    MARK: - Additional funcs
    
    func setProducts(category: String, subCategory: String) {
        
        hideMenu()
        
        FireAPI.shared.getProducts(category: category, subCategoriy: subCategory) { docs in
            
            self.products.removeAll()
            self.products = docs
            self.collectionView.reloadData()
            
            for product in self.products {
                FireAPI.shared.getFirstImage(document: product) { image in
                    
                    product.image = image
                    self.collectionView.reloadData()
                }
            }
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
        
        cell.layer.cornerRadius = CGFloat(5)
        cell.backgroundColor = .systemGray6
        cell.image.backgroundColor = .white
    
        if isFiltering {
            cell.name.text = filtredProducts[indexPath.row].name
            cell.price.text = "\(filtredProducts[indexPath.row].price)" + NSLocalizedString("Rub", comment: "")
            cell.image.image = filtredProducts[indexPath.row].image
            
        } else {
            cell.name.text = products[indexPath.row].name
            cell.price.text = "\(products[indexPath.row].price)" + NSLocalizedString("Rub", comment: "")
            cell.image.image = products[indexPath.row].image
//            cell.image.image = UIImage(named: "5")
            
        }

    
        return cell
    }
    
//    MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool { selectedIndex.0 = indexPath.section
        selectedIndex.1 = indexPath.row
        return true
    }
    
}

//MARK: - UISearchResultsUpdating, UISearchControllerDelegate

extension StoreCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filtredProducts.removeAll()
        
        if searchText.count > 3 {
            
            FireAPI.shared.findProduct(name: searchText) { docs in
                self.filtredProducts += docs
                self.collectionView.reloadData()
                
                for doc in docs {
                    FireAPI.shared.getFirstImage(document: doc, completion:{ image in
                        doc.image = image
                        self.collectionView.reloadData()
                    })
                }
                
            }
        }
        if searchBarIsEmpty {
            collectionView.reloadData()
        }
    }
    
}
