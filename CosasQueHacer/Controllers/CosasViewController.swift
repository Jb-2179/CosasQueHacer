//
//  ViewController.swift
//  CosasQueHacer
//
//  Created by Jesus Betancourt on 9/28/19.
//  Copyright © 2019 Jesus Betancourt. All rights reserved.
//

import UIKit

class CosasViewController: UITableViewController {

  
  var asuntoArray = [Asunto]()
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nuevoAsunto1 = Asunto()
    nuevoAsunto1.nombre = "Compra Leche"
    asuntoArray.append(nuevoAsunto1)
    
    let nuevoAsunto2 = Asunto()
    nuevoAsunto2.nombre = "Compra Leche"
    asuntoArray.append(nuevoAsunto2)
    
    let nuevoAsunto3 = Asunto()
    nuevoAsunto3.nombre = "Compra Leche"
    asuntoArray.append(nuevoAsunto3)
    
      // if let items = defaults.array(forKey: "CosasArray") as? [String] {
      // itemArray = items
      // }
    
  }


  
   //MARK - TableView DataSource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return asuntoArray.count
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CosaCell", for: indexPath)
  
    let asunto = asuntoArray[indexPath.row]

    cell.textLabel?.text = asunto.nombre
    
    cell.accessoryType = asunto.completado == true ? .checkmark : .none
  
    return cell
    
  }
  
  //MARK - TableView Delegate Methods
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    asuntoArray[indexPath.row].completado = !asuntoArray[indexPath.row].completado
    
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  //MARK - Add New Items
  
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Añade un Nuevo Asunto", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Añade Asunto", style: .default) { (action) in
      
      if let asunto = textField.text {
        if asunto.isEmpty {
          return
        }
      
        let nuevoAsunto = Asunto()
        nuevoAsunto.nombre = asunto
  
        self.asuntoArray.append(nuevoAsunto)
        
        self.defaults.set(self.asuntoArray, forKey: "AsuntosArray")
      }
      
      
      
      
      self.tableView.reloadData()
      
      
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Entra un nuevo asunto"
      textField = alertTextField
    }
    
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
}
