//
//  EntriesViewController.swift
//  Travelogue
//
//  Created by Jacob Sokora on 7/19/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit

class EntriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var trip: Trip?
    var entries: [Entry] = []
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        if let trip = trip {
            entries = trip.entries.allObjects as! [Entry]
        }
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let trip = trip {
            entries = trip.entries.allObjects as! [Entry]
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(type(of: segue.destination))
        if let navigationController = segue.destination as? UINavigationController,
            let destination = navigationController.visibleViewController as? EntriesDetailViewController {
            if let selectedRow = tableView.indexPathForSelectedRow?.row {
                destination.entry = entries[selectedRow]
            }
            destination.trip = trip
        }
    }
}

extension EntriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = dateFormatter.string(from: entry.date)
        return cell
    }
}

extension EntriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let entry = self.entries.remove(at: indexPath.row)
            do {
                let context = entry.managedObjectContext
                context?.delete(entry)
                try context?.save()
                success(true)
                self.tableView.reloadData()
            } catch {
                print("Failed to delete trip: \(error.localizedDescription)")
                success(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
