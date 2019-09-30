
import UIKit

class CosasViewController: UITableViewController {

  
  var asuntoArray = [Asunto]()
  
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("misAsuntos.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // let myFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    // print(myFile)
    
    loadAsuntos()
    
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
            let nuevoAsunto = Asunto()
            nuevoAsunto.nombre = asunto
  
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
  
  func saveAsuntos() {
    
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(asuntoArray)
      try data.write(to: dataFilePath!)
    } catch {
      print("Error encoding asunto array, \(error)")
    }
    
    
      tableView.reloadData()
    
    }
  
  func loadAsuntos() {
    
    if let data = try? Data(contentsOf: dataFilePath!) {
      let decoder = PropertyListDecoder()
      do {
        asuntoArray = try decoder.decode([Asunto].self, from: data)
      } catch {
        print("Error decoding asuntos array, \(error)")
      }
    }
    
  }
  
}
