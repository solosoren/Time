//
//  CategoryViewController.swift
//  Time
//
//  Created by Soren Nelson on 6/16/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, InitialDataUpdater {
    
    @IBOutlet var collectionView: UICollectionView!
    var passOnCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }

// MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryContoller.sharedInstance.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = CategoryContoller.sharedInstance.categories[indexPath.item]
        item.categoryNameLabel.text = category.name
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = CGSize(width:(self.view.bounds.width / 2) - 2, height:140)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.passOnCategory = CategoryContoller.sharedInstance.categories[indexPath.item]
        self.performSegue(withIdentifier: "CategoryProjectsSegue", sender: self)
        
    }
    
    func updateTableView() {
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryProjectsSegue" {
            let vc = segue.destination as! CategoryProjectsViewController
            vc.category = self.passOnCategory
        }
    }
}
