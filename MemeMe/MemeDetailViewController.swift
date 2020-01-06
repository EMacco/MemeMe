//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Emmanuel Okwara on 06/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, HomeViewDelegate {
    
    var meme: Meme!
    @IBOutlet weak var memeImageView: UIImageView!
    let editMemeIdentifier = "editMemeSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeImageView.image = meme.memedImage
        
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editMeme))
        navigationItem.rightBarButtonItem = editBtn
    }
    
    @objc func editMeme() {
        performSegue(withIdentifier: editMemeIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            let createMemeVC = navVC.viewControllers.first as! ViewController
            createMemeVC.currentMeme = meme
            createMemeVC.homeViewDelegate = self
        }
    }
    
    func reloadDataView(_ meme: Meme?) {
        memeImageView.image = meme?.memedImage
        self.meme = meme
    }
}
