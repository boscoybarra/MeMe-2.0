//
//  MemeTableViewController.swift
//  ImagePickerSimple
//
//  Created by J B on 5/23/17.
//  Copyright © 2017 J B. All rights reserved.
//

import UIKit


private let reuseIdentifier = "memeTableCell"

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let memes = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = memes.memedImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeme = appDelegate.memes[indexPath.row]
        let detailController = self.storyboard?.instantiateViewController(withIdentifier:"MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = selectedMeme
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
}
