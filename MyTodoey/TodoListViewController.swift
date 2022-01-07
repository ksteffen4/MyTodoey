//
//  ViewController.swift
//  MyTodoey
//
//  Created by Keith Steffen on 1/6/22.
//

import UIKit

class TodoListViewController: UITableViewController {

    struct ItemEntry {
        let text: String
        var isChecked = false
    }
    
    let defaults = UserDefaults.standard
    
    var itemArray = ["Find Mike",
                     "Buy Eggs",
                     "Destroy Demogorgon"]
    var checkmarkArray = [false, false, false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let rawData = defaults.array(forKey: "TodoListArray")
        if rawData != nil {
            itemArray = rawData as! [String]
        }
        let rawBoolData = defaults.array(forKey: "CheckboxArray")
        if rawBoolData != nil {
            checkmarkArray = rawBoolData as! [Bool]
        }
    }

    //MARK: - override methods to populate list
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.accessoryType = checkmarkArray[indexPath.row] ? .checkmark : .none
        return cell
    }

    //MARK: - override methods for list item selection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            checkmarkArray[indexPath.row].toggle()
            cell.accessoryType =  checkmarkArray[indexPath.row] ? .checkmark : .none
            self.defaults.set(self.checkmarkArray, forKey: "CheckboxArray")
        }
        
    }
    
    //MARK: - Process add item button
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField? = nil
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { _ in
            if let text = textField?.text, text != "" {
                DispatchQueue.main.async {
                    self.itemArray.append(text)
                    self.checkmarkArray.append(false)
                    self.defaults.set(self.itemArray, forKey: "TodoListArray")
                    self.defaults.set(self.checkmarkArray, forKey: "CheckboxArray")
                    self.tableView.reloadData()
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
}




