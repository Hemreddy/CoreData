//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Hemareddy Halli on 5/9/19.
//  Copyright © 2019 Apex Capital Corp. All rights reserved.
//

import UIKit
import CoreData

let kTabelCellIdentifier = "TableCellIdentifier"
class ViewController: UIViewController,UITabBarDelegate, UITableViewDataSource {
    
    var mPeople:[NSManagedObject] = []
    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.register(UITableViewCell.self, forCellReuseIdentifier: kTabelCellIdentifier)
    }
    
    override func viewWillAppear(_ animation: Bool)
    {
        fetchRecords()
        super.viewWillAppear(animation)
    }

    @IBAction func addRecord(_ sender: UIBarButtonItem) {
        let alertToCollectRecord = UIAlertController(title: NSLocalizedString(kAddRecord, comment: ""), message: NSLocalizedString(kAddNewRecord, comment: ""), preferredStyle: UIAlertController.Style.alert)
      
        let saveAlert = UIAlertAction(title: NSLocalizedString(kSave, comment: ""), style: .default) {
            [unowned self] action in
            guard let textfield = alertToCollectRecord.textFields?.first, let text = textfield.text else {
                return
            }
            self.saveRecord(name: text)
            self.mTableView.reloadData()
        
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString(kCancel, comment: ""), style: .cancel)
        alertToCollectRecord.addTextField()
        alertToCollectRecord.addAction(saveAlert)
        alertToCollectRecord.addAction(cancelAction)
        present(alertToCollectRecord, animated: true)
        
    }
    
    func fetchRecords()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let manageObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kPerson)
        
        do {
            mPeople = try manageObjectContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Faild to fetch records with Error : \(error)")
        }
    }
    
    func saveRecord(name: String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: kPerson, in: managedContext)!
        
        let  managedObject = NSManagedObject(entity:entity, insertInto:managedContext)
        
        managedObject.setValue(name, forKeyPath:kName)
        
        do {
            try managedContext.save()
            mPeople.append(managedObject)
        }catch let error as NSError {
            print("Faild to save with Error : \(error)")
        }
        
    }


//MARK: TableView Datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTabelCellIdentifier, for: indexPath)
        
        let person = mPeople[indexPath.row]
        cell.textLabel?.text = person.value(forKeyPath:kName) as? String
        return cell
    }
    
}

