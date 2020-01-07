//
//  AddViewController.swift
//  Notas Diarias
//
//  Created by César  Ferreira on 07/01/20.
//  Copyright © 2020 César  Ferreira. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var textViewNote: UITextView!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func saveNote(_ sender: Any) {
        
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    private func initialSetup() {
        self.textViewNote.becomeFirstResponder()
    }
   
    private func saveNewNote() {
        
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
        
        newNote.setValue( self.textViewNote.text , forKey: "text")
        newNote.setValue( Date(), forKey: "date")
        
        do {
            try context.save()
        } catch let error {
            print("Erro ao salvar anotação: " + error.localizedDescription)
        }
        
    }
    
}
