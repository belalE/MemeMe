//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by mac pro on 8/17/17.
//  Copyright © 2017 Elsiesy Industries. All rights reserved.
//

import UIKit

class MemesTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var TableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var memes = appDelegate.memes
        
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var memes = appDelegate.memes
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) 
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.toptext)...\(meme.bottomtext)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        TableView.reloadData()
    }
}
