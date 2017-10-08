//
//  SavedSearches.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/7/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Alamofire
import SwiftyJSON

class SavedSearchesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var savedSearchesItem: [SaveSearch] = []
    var noItems = ["No items to display"]
    var rootRef: FIRDatabaseReference!
    
    let savedsearchesToHome = "savedsearchesToHome"
    let savedsearchesToProfile = "savedsearchesToProfile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        rootRef = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
        print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
        print("ifRef: \(idRef)")
        
        let listRef = idRef.child("savedsearches")
        
        debugPrint("listRef: \(listRef)")
        
        listRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let structItem = SaveSearch(snapshot: item as! FIRDataSnapshot)
                print("structItem: \(structItem)")
                self.savedSearchesItem.append(structItem)
                print("savedSearchedItem List: \(self.savedSearchesItem)")
            }
            //self.items = newItems
            //self.tableView.reloadData()
            //debugPrint("ITEMS: \(self.items)")
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedSearchesItem.count > 0 {
            return savedSearchesItem.count
        } else {
            return noItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellSavedSearch", for: indexPath)
        
        //cell.textLabel?.text = fruits[indexPath.row]
        
        if savedSearchesItem.count > 0 {
            let searchedData = savedSearchesItem[indexPath.row]
            cell.textLabel?.text = searchedData.keyword2
            cell.detailTextLabel?.text = searchedData.location2
        } else {
            let noData = noItems[indexPath.row]
            cell.textLabel?.text = noData
            cell.detailTextLabel?.text = " "
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Saved Searches"
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedsearchesToProfile, sender: nil)
    }
    
    @IBAction func appliedAction(_ sender: UIButton) {
        
    }
    
    @IBAction func savedAction(_ sender: UIButton) {
        
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedsearchesToHome, sender: nil)
    }
    
}
