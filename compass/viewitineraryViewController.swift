//
//  EditEventVC.swift
//  compass
//
//  Created by Katherine Chao on 3/31/25.
//

import UIKit

// depending on if this is already made or a new one a nre tag needs to be made
// need a bool if new or not


class viewitineraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var flightInfo: String = ""
    var stayInfo: String = ""
    var eventTitle: String = ""
    var numdays: Int = 0
    var activitiesForDisplay: [Activity] = []
    var currtag = 0;

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
    
    @IBOutlet weak var staylabel: UILabel!
    @IBOutlet weak var flightlabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    func populateinfo() {
        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            titlelabel.text = itinerary.name
            staylabel.text = itinerary.stays
            flightlabel.text = itinerary.flights
            numdays = itinerary.numdays
            allActivities = itinerary.activities
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

    // Action when the day is changed from the segmented control
    @IBAction func dayChanged(_ sender: UISegmentedControl) {
        reloadActivitiesForSelectedDay()  // Reload activities for the selected day
        tableView.reloadData()  // Reload table view data to reflect the new activities
    }

    // Function to reload the activities for the selected day
    func reloadActivitiesForSelectedDay() {
        let selectedDay = tripTypeSegmentedControl.selectedSegmentIndex + 1
        activitiesForDisplay.removeAll()

        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            if let activitiesForSelectedDay = itinerary.activities[selectedDay] {
                activitiesForDisplay = activitiesForSelectedDay
                tableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editsegue" {
            if let destinationVC = segue.destination as? viewitineraryViewController {
                if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
                    destinationVC.currtag = itinerary.tag
                }
            }
        }
    }
}





