//
//  GalleryViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/22/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    var imageArray = [UIImage]()
    var countSelected = 0
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var sendImageView: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        galleryCollectionView.register(UINib.init(nibName: "PhotosListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotosListCollectionViewCell")
        
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
        print(imageArray.count)
    }
    

    @IBAction func closeClickButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

//Mark: - UICollectionView Datasource & Delegate
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosListCollectionViewCell", for: indexPath) as! PhotosListCollectionViewCell
        cell.photoImageView.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 20)/3, height: (UIScreen.main.bounds.width - 20)/3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosListCollectionViewCell
        if cell.wasClickImageView.image == UIImage(named: "unclick") {
            countSelected = countSelected - 1
        } else {
            countSelected = countSelected + 1
        }
        print(countSelected)
        if countSelected > 0 {
            sendImageView.isHidden = false
        } else {
            sendImageView.isHidden = true
        }
    }
    
}
