//
//  ViewController.swift
//  Travelogue
//
//  Created by Jacob Sokora on 7/19/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit
import CoreData

class TripsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var trips: [Trip] = []
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        do {
            trips = try context.fetch(request)
        } catch {
            print("Error loading trips: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addTrip(_ sender: Any) {
        let alert = UIAlertController(title: "Add Trip", message: nil, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Trip Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { action in
            if let nameField = alert.textFields?.first, let name = nameField.text {
                let trip = Trip(name: name)
                if let trip = trip {
                    do {
                        try trip.managedObjectContext?.save()
                        self.trips.append(trip)
                        self.tableView.reloadData()
                    } catch {
                        print("Failed to save category: \(error.localizedDescription)")
                    }
                }
            }
        })
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntriesViewController,
            let selectedRow = tableView.indexPathForSelectedRow?.row {
            print(trips[selectedRow].name)
            destination.trip = trips[selectedRow]
        }
    }
}

extension TripsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let trip = trips[indexPath.row]
        cell.textLabel?.text = trip.name
        let endDateString = trip.endDate == nil ? "present" : dateFormatter.string(from: trip.endDate!)
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: trip.startDate))-\(endDateString)"
        return cell
    }
}

extension TripsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (ac: UIContextualAction, view: UIView, success: @escaping (Bool) -> Void) in
            let trip = self.trips[indexPath.row]
            if trip.entries.count != 0 {
                let alert = UIAlertController(title: "Warning!", message: "Your trip contains travelogue entries, are you sure you want to delete it?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive){ action in
                    success(self.deleteTrip(at: indexPath.row))
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){ action in
                    success(false)
                })
                self.present(alert, animated: true)
            } else {
                success(self.deleteTrip(at: indexPath.row))
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func deleteTrip(at index: Int) -> Bool {
        let trip = trips.remove(at: index)
        do {
            let context = trip.managedObjectContext
            context?.delete(trip)
            try context?.save()
            self.tableView.reloadData()
            return true
        } catch {
            print("Failed to delete trip: \(error.localizedDescription)")
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
