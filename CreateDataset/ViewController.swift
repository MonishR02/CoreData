//
//  ViewController.swift
//  CreateDataset
//
//  Created by monish-pt4670 on 22/10/1943 Saka.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var data : [Data]?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
    }
    func fetchData()
    {
        do{
            try self.data = context.fetch(Data.fetchRequest())
            self.tableView.reloadData()
    }
        catch{
            fatalError()
        }
    }
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Info", message: "Insert the data", preferredStyle: .alert)
        alert.addTextField()
        let doneButton = UIAlertAction(title: "Add", style: .default, handler: {(action) in
            let text = alert.textFields![0]
            let newAdd = Data(context: self.context)
            newAdd.info = text.text
            do{
                try self.context.save()
            }
            catch{
                fatalError()
            }
            self.fetchData()
            
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler:nil)
        alert.addAction(doneButton)
        alert.addAction(cancel)
        self.present(alert,animated: true)
        
    }
}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        let text = self.data![indexPath.row]
        cell.textLabel?.text = text.info
        cell.isSelected = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.data![indexPath.row]
        let alert = UIAlertController(title: "Edit", message: "Edit the already present data", preferredStyle: .alert)
        alert.addTextField()
        let textfield = alert.textFields![0]
        textfield.text = data.info
        let button = UIAlertAction(title: "Save", style: .default, handler:{ (action) in
            let textfield = alert.textFields![0]
            data.info = textfield.text
            do{
            try self.context.save()
            }
            catch{
                fatalError()
            }
            self.fetchData()
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(button)
        self.present(alert, animated: true)
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {(action,view,completionHandler) in
            let deleteRow = self.data![indexPath.row]
            self.context.delete(deleteRow)
            do{
                try self.context.save()
            }
            catch{
                fatalError()
            }
            self.fetchData()
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
}


