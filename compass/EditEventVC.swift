//
//  EditEventVC.swift
//  compass
//
//  Created by Katherine Chao on 3/31/25.
//

import UIKit

// depending on if this is already made or a new one a nre tag needs to be made
// need a bool if new or not
var allActivities: [Int: [Activity]] = [:]

class EditEventVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var flightInfo: String = ""
    var stayInfo: String = ""
    var eventTitle: String = ""
    var numdays: Int = 0
    var activitiesForDisplay: [Activity] = []
    var currtag: Int = 1
    let textCellIdentifier = "TextCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Enable dynamic row sizing
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        populateinfo()

    }
    
    func populateinfo() {
        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            titleTextField.text = itinerary.name
            stayTextField.text = itinerary.stays
            flightTextField.text = itinerary.flights
            numdays = itinerary.numdays
            allActivities = itinerary.activitiesforday
        }
        tripTypeSegmentedControl.removeAllSegments()

        for day in 1...numdays {
            let title = "Day \(day)"
            tripTypeSegmentedControl.insertSegment(withTitle: title, at: day - 1, animated: false)
        }
            
            tripTypeSegmentedControl.selectedSegmentIndex = 0
            reloadActivitiesForSelectedDay()
    }
    
    @IBOutlet weak var tripTypeSegmentedControl: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(allActivities.count)
        return activitiesForDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)

        let activity = activitiesForDisplay[indexPath.row]
            
            // Title label
            let titleLabel = UILabel()
            titleLabel.text = activity.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.backgroundColor = UIColor.white
            cell.contentView.addSubview(titleLabel)
            
            // Image View
            let imageView = UIImageView()
            imageView.image = activity.picture  // Replace with your image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(imageView)
            
            
            NSLayoutConstraint.activate([
                // Title label constraints
                titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                titleLabel.widthAnchor.constraint(equalToConstant: 500),
                titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
                titleLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),
                // Image view constraints (right side)
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                imageView.widthAnchor.constraint(equalToConstant: 120),
                imageView.heightAnchor.constraint(equalToConstant: 120),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30)
                
            ])
        
        return cell
    }

    @IBOutlet weak var titleTextField: UITextField!
    

    @IBOutlet weak var stayTextField: UITextField!
    
    @IBOutlet weak var flightTextField: UITextField!
    

    @IBAction func addday(_ sender: Any) {
        let newDay = numdays + 1
        tripTypeSegmentedControl.insertSegment(withTitle: "Day \(newDay)", at: newDay - 1, animated: false)
        numdays += 1
        // Initialize empty activity array for the new day
        allActivities[newDay] = []
    }
    
    @IBAction func dayChanged(_ sender: UISegmentedControl) {
        reloadActivitiesForSelectedDay()  // Reload activities for the selected day
        tableView.reloadData()  // Reload table view data to reflect the new activities

    }
    
    // Reload the activities for the selected day
    func reloadActivitiesForSelectedDay() {
        let selectedDay = tripTypeSegmentedControl.selectedSegmentIndex + 1
        activitiesForDisplay.removeAll()

        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            if let activitiesForSelectedDay = itinerary.activitiesforday[selectedDay] {
                activitiesForDisplay = activitiesForSelectedDay
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func addactivity(_ sender: Any) {
        let alert = UIAlertController(title: "New Activity", message: "Enter the activity details", preferredStyle: .alert)

        // Add text fields
        alert.addTextField { textField in
            textField.placeholder = "Activity Title"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Additional Info (optional)"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Image name"
        }

        // Add actions
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let title = alert.textFields?[0].text ?? "Untitled"
            let info = alert.textFields?[1].text ?? ""
            let imageName = alert.textFields?[2].text ?? "defaultImage"

            let image = UIImage(named: imageName) ?? UIImage(systemName: "photo")!

            // Create new activity
            let newActivity = Activity(title: title, currentTime: Date().timeIntervalSince1970, picture: image)

            // Get the selected day from the segmented control
            let selectedDay = self.tripTypeSegmentedControl.selectedSegmentIndex + 1

            // Add activity to the selected day
            if allActivities[selectedDay] != nil {
                allActivities[selectedDay]?.append(newActivity)
            } else {
                allActivities[selectedDay] = [newActivity]
            }

            // Sync activities back to the corresponding itinerary
            if let index = DataManager.shared.allItineraries.firstIndex(where: { $0.tag == self.currtag }) {
                DataManager.shared.allItineraries[index].activitiesforday = allActivities
            }

            // Reload the table view if it's the selected day
            self.reloadActivitiesForSelectedDay()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        flightInfo = flightTextField.text ?? ""
        stayInfo = stayTextField.text ?? ""
        eventTitle = titleTextField.text ?? ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewpagesegue" {
            if let destinationVC = segue.destination as? viewitineraryViewController {
                if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
                    destinationVC.currtag = itinerary.tag
                }
            }
        }
    }
}




