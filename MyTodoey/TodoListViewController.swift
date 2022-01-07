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
    
    var itemArray = [ItemEntry(text: "Find Mike"),
                     ItemEntry(text: "Buy Eggs"),
                     ItemEntry(text: "Destroy Demogorgon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("in \(#function)")
    }

    //MARK: - override methods to populate list
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].text
        cell.accessoryType = itemArray[indexPath.row].isChecked ? .checkmark : .none
        return cell
    }

    //MARK: - override methods for list item selection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            itemArray[indexPath.row].isChecked.toggle()
            cell.accessoryType =  itemArray[indexPath.row].isChecked ? .checkmark : .none
        }
        
    }
    
    //MARK: - Process add item button
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField? = nil
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { _ in
            print("Add button pressed")
            if let text = textField?.text {
                print("The following was entered: \(text)")
                DispatchQueue.main.async {
                    self.itemArray.append(ItemEntry(text: text))
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




