//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Emmanuel Okwara on 05/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController, HomeViewDelegate {
    
    var memes: [Meme]! {
        return MemesManager.shared.getAllMemes()
    }
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    let memeDetailIdentifier = "MemeDetailViewController"
    let createMemeSegueIdentifier = "createMemeSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadDataView(nil)
    }
    
    override func viewDidLayoutSubviews() {
        let space:CGFloat = 3.0
        var dimension: CGFloat = 0
        var numberOfCellsPerRow: CGFloat = 3
        if let landscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape, landscape {
            numberOfCellsPerRow = 6
        }

        dimension = (view.frame.size.width - (numberOfCellsPerRow - 1) * space) / numberOfCellsPerRow
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemeCollectionViewCell
        cell.memedImageView.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: memeDetailIdentifier) as! MemeDetailViewController
        controller.meme = memes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == createMemeSegueIdentifier {
            let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? MemeViewController
            controller?.homeViewDelegate = self
        }
    }
    
    func reloadDataView(_ meme: Meme?) {
        self.collectionView.reloadData()
    }
    
}
