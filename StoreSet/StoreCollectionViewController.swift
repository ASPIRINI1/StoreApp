//
//  StoreCollectionViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class StoreCollectionViewController: UICollectionViewController {
    
    let categoryVC = CategoryTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
    }

    @IBAction func CategoryButton(_ sender: Any) {
        
        
        
        
        func showMenu(){
            print("pres")
            UIView.animate(withDuration: 0.3){
                self.categoryVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/1.5, height: UIScreen.main.bounds.size.height)
                self.addChild(self.categoryVC)
                self.view.addSubview(self.categoryVC.view)
                AppDelegate.isCategoryVC = false
            }

        }
        
        func hideMenu(){
            print("hide")
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)// as StoreCollectionViewCell
    
        
    
        return cell
    }

}
