//
//  ViewController.swift
//  CosasQueHacer
//
//  Created by Jesus Betancourt on 9/28/19.
//  Copyright © 2019 Jesus Betancourt. All rights reserved.
//

import UIKit

class CosasViewController: UITableViewController {

  
  let itemArray = ["Find Mike", "Find Jose", "Find Jack"]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


  
   //MARK - TableView DataSource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return itemArray.count
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
  let cell = tableView.dequeueReusableCell(withIdentifier: "CosaCell", for: indexPath)
    
    cell.textLabel?.text = itemArray[indexPath.row]
  
    
    return cell
    
  }
  
  //MARK - TableView Delegate Methods
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }

}
