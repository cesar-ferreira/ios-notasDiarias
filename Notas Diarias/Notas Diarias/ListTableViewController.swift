//
//  ListTableViewController.swift
//  Notas Diarias
//
//  Created by César  Ferreira on 07/01/20.
//  Copyright © 2020 César  Ferreira. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var notes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getNotes()
    }
    
    private func getNotes() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let ordenation = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [ordenation]
        
        do {
            let getNotes = try context.fetch(request)
            self.notes = getNotes as! [NSManagedObject]
            
            self.tableView.reloadData()
        } catch let error {
            print("Erro ao recuperar dados: " + error.localizedDescription)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)

        // Configure the cell...
        let note = self.notes[ indexPath.row ]
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        let newDate = dateFormatter.string(from: note.value(forKey: "date") as! Date)
        
        cell.textLabel?.text = note.value(forKey: "text") as? String
        cell.detailTextLabel?.text = String( describing: newDate )

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let note = self.notes[ indexPath.row ]
        
        self.performSegue(withIdentifier: "segue-note", sender: note)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ( segue.identifier == "segue-note" ) {
            
            let addViewController = segue.destination as! AddViewController
            addViewController.note = sender as? NSManagedObject
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if( editingStyle == UITableViewCell.EditingStyle.delete ) {
            
            self.context.delete(self.notes[indexPath.row])
            self.notes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try self.context.save()
            } catch let error {
                print("Erro ao deletar anotação: " + error.localizedDescription)
            }
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
