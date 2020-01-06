//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Emmanuel Okwara on 05/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, HomeViewDelegate {
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    let reusableCellIdentifier = "SentMemeTableViewCell"
    let memeDetailIdentifier = "MemeDetailViewController"
    let createMemeSegueIdentifier = "createMemeSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadDataView(nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier) as! SentMemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memedImageView.image = meme.memedImage
        cell.memedTextLbl.text = "\(meme.topText)...\(meme.bottomText)"
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.image = #imageLiteral(resourceName: "trash")
        return action
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: memeDetailIdentifier) as! MemeDetailViewController
        controller.meme = memes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == createMemeSegueIdentifier {
            let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? ViewController
            controller?.homeViewDelegate = self
        }
    }
    
    func reloadDataView(_ meme: Meme?) {
        self.tableView.reloadData()
    }
    
}
