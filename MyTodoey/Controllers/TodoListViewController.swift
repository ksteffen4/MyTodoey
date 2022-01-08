//
//  ViewController.swift
//  MyTodoey
//
//  Created by Keith Steffen on 1/6/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
                    let newItem = Item(context: self.context)
                    newItem.title = text
                    newItem.done = false
                    self.items.append(newItem)
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
        do {
            try context.save()
        } catch {
            print("Could not save context: \(error)")
        }
        tableView.reloadData()
    }
    
    func retrieveData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            items = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}




