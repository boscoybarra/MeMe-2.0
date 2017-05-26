//
//  MemeCollectionViewController.swift
//  ImagePickerSimple
//
//  Created by J B on 5/23/17.
//  Copyright © 2017 J B. All rights reserved.
//

import UIKit

    private let reuseIdentifier = "memeCollectionCell"

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: IBOutlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

    }
    
    // To be able to see the Meme we should reload the collection view when returning from the Meme Editor.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        collectionView?.reloadData()
    }



    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return appDelegate.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let selectedMeme = appDelegate.memes[indexPath.row]
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = selectedMeme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}
