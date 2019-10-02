//
//  CategoriaViewController.swift
//  CosasQueHacer
//
//  Created by Jesus Betancourt on 9/30/19.
//  Copyright © 2019 Jesus Betancourt. All rights reserved.
//

import UIKit
import CoreData


class CategoriaViewController: UITableViewController {

  var categoriaArray = [Categoria]()

  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
        super.viewDidLoad()

      loadCategorias()
    
    }

  //MARK - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Añade una nueva Categoría", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Nueva Categoría", style: .default) { (action) in
      
      if let categoria = textField.text {
        if categoria.isEmpty {
          return
        }
        else {
          
          
          
          let nuevaCategoria = Categoria(context: self.context)
          nuevaCategoria.tipo = categoria
          
          
          self.categoriaArray.append(nuevaCategoria)
          self.saveCategorias()
        }
      }
    }
    
    alert.addTextField { (field) in
      field.placeholder = "Entra una nueva categoría"
      textField = field
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  
  //Mark: TableView DataSource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categoriaArray.count
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
    
    let categoria = categoriaArray[indexPath.row]
    
    cell.textLabel?.text = categoria.tipo
    
    
    
    return cell
    
  }
  
  
  
  //Mark: TableView Delegate Methods

  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "goToAsuntos", sender: self)
    
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let destinationVC = segue.destination as! CosasViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoriaArray[indexPath.row]
    }
  }
  
  
  //Mark: Data Manipulation Methods

  func saveCategorias() {
    
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    
    tableView.reloadData()
    
  }
  
  func loadCategorias() {
    
    let request: NSFetchRequest<Categoria> = Categoria.fetchRequest()

    do {
      categoriaArray = try context.fetch(request)
    } catch {
      print("Error saving context \(error)")
    }
    
    
    tableView.reloadData()
  }
  
}


