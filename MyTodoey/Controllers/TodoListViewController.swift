//
//  ViewController.swift
//  MyTodoey
//
//  Created by Keith Steffen on 1/6/22.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    let defaults = UserDefaults.standard
    

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        retrieveData()
    }

    //MARK: - override methods to populate list
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    //MARK: - override methods for list item selection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].done.toggle()
        saveData()
        
    }
    
    //MARK: - Process add item button
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField? = nil
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { _ in
            if let text = textField?.text, text != "" {
                DispatchQueue.main.async {
                    self.items.append(Item(text))
                    self.saveData()
                }
            }
            
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - save and retrive data from storage
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.items)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array: \(error)")
        }
        tableView.reloadData()
    }
    
    func retrieveData() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error on decode: \(error)")
                items = []
            }
        }
    }
}




