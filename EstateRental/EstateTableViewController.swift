//
//  EstateTableViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 3/11/2020.
//

import UIKit
import CoreData

class EstateTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var viewContext: NSManagedObjectContext?
    
    var estateName: [String] = []
    
    lazy var fetchedResultsController: NSFetchedResultsController<EstateManagedObject> = {
        
        let fetchRequest = NSFetchRequest<EstateManagedObject>(entityName:"EstateManagedObject")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
        
        //        if let code = code {
        //            fetchRequest.predicate = NSPredicate(format: "dept_id = %@", code)
        //        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: viewContext!,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dataController = (UIApplication.shared.delegate as? AppDelegate)!.dataController!
        let dataController = AppDelegate.dataController!
        viewContext = dataController.persistentContainer.viewContext
        
//        let dataController = (UIApplication.shared.delegate as? AppDelegate)!.dataController!
//        viewContext = dataController.persistentContainer.viewContext

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print(Estate.estateData.count)
        
        fetchedResultsController.fetchedObjects?.forEach {
            
            guard $0.estate != nil else {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            
            if (!estateName.contains($0.estate!)) {
                estateName.append($0.estate!)
            }
        }
        
//        Estate.estateData.forEach {
//            if (!estateName.contains($0.estate)) {
//                estateName.append($0.estate)
//            }
//        }

        print("EstateTableController estateName.count")
        print(estateName.count)
        return estateName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EstateCell", for: indexPath)

        // Configure the cell...
//        print(Estate.getEstateNames())
//        cell.textLabel?.text = Estate.getEstateNames()[indexPath.row]
        cell.textLabel?.text = estateName[indexPath.row]
        
//        cell.textLabel?.text = fetchedResultsController.object(at: indexPath).estate

        return cell
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let viewController = segue.destination as? EstateChoiceTableViewController {
            
            let selectedIndex = tableView.indexPathForSelectedRow!
            
//            viewController.estate = Estate.getEstateNames()[selectedIndex.row]
            viewController.estate = estateName[selectedIndex.row]
        }
    }
    

}
