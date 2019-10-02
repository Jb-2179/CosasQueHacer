
import UIKit
import CoreData

class CosasViewController: UITableViewController {

  
  var asuntoArray = [Asunto]()
  
  var selectedCategory : Categoria? {
    didSet{
      loadAsuntos()
    }
  }
  
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // let myFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
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
    
    // asuntoArray[indexPath.row].setValue("Ir al Dentista", forKey: "nombre")
    
    // context.delete(asuntoArray[indexPath.row]
    // itemArray.remove(at: indexPath.row]
    
    
    asuntoArray[indexPath.row].completado = !asuntoArray[indexPath.row].completado
    
    saveAsuntos()
    
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
          else {
            
            
            
            let nuevoAsunto = Asunto(context: self.context)
            nuevoAsunto.nombre = asunto
            nuevoAsunto.completado = false
            nuevoAsunto.parentCategory = self.selectedCategory
            
  
            self.asuntoArray.append(nuevoAsunto)
            self.saveAsuntos()
          }
        }
     }
      
      alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Entra un nuevo asunto"
        textField = alertTextField
      }
    
      alert.addAction(action)
    
      present(alert, animated: true, completion: nil)
    
  }
  
  
  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath) {
    
    context.delete(asuntoArray[indexPath.row])
    asuntoArray.remove(at: indexPath.row)
    
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
    
    saveAsuntos()
  }
  
  
  
  
  func saveAsuntos() {
    
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    
      tableView.reloadData()
    
    }
  
  func loadAsuntos(with request: NSFetchRequest<Asunto> = Asunto.fetchRequest(), predicate: NSPredicate? = nil) {
 
    let categoryPredicate = NSPredicate(format: "parentCategory.tipo MATCHES %@", selectedCategory!.tipo!)
    
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    } else {
      request.predicate = categoryPredicate
    }
    
    
    do {
       asuntoArray = try context.fetch(request)
    } catch {
      print("Error saving context \(error)")
    }
    
    
      tableView.reloadData()
  }

}

//MARK: Search bar methods

extension CosasViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    let request: NSFetchRequest<Asunto> = Asunto.fetchRequest()
    
    let predicate = NSPredicate(format: "nombre CONTAINS[cd] %@", searchBar.text!)
    
     request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
    
    loadAsuntos(with: request, predicate: predicate)
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchBar.text?.count == 0 {
      loadAsuntos()
      
      
      DispatchQueue.main.async {
        
         searchBar.resignFirstResponder()
        
      }
     
    
    
    
    }
  }
  
  
}
