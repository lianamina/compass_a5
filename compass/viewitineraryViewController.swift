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
    var noActivitiesLabel: UILabel!

    let textCellIdentifier = "TextCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // basically ignore this
        noActivitiesLabel = UILabel()
        noActivitiesLabel.text = "No activities added for this day"
        noActivitiesLabel.textColor = .gray
        noActivitiesLabel.font = UIFont.systemFont(ofSize: 18)
        noActivitiesLabel.textAlignment = .center
        noActivitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        noActivitiesLabel.isHidden = true // Initially hidden
        view.addSubview(noActivitiesLabel)
        NSLayoutConstraint.activate([
            noActivitiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noActivitiesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noActivitiesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noActivitiesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
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
        
            var votebutton: UIButton
            if let existingButton = cell.contentView.viewWithTag(100) as? UIButton {
                votebutton = existingButton
            } else {
                // Create a new button if it doesn't exist
                votebutton = UIButton(type: .system)
                votebutton.setTitle("Vote", for: .normal)
                votebutton.setTitleColor(.white, for: .normal)
                votebutton.backgroundColor = .systemOrange
                votebutton.layer.cornerRadius = 8
                votebutton.tag = 100 // Assign a tag to identify the button
                votebutton.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(votebutton)
            }
            votebutton.addTarget(self, action: #selector(voteButtonPressed(_:)), for: .touchUpInside)
            // Set the visibility of the button based on the didvote property
            votebutton.isHidden = activity.didvote
            
            
            NSLayoutConstraint.activate([
                // Title label constraints
                titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                titleLabel.widthAnchor.constraint(equalToConstant: 500),
                titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
//                titleLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),
                // Image view constraints (right side)
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                imageView.widthAnchor.constraint(equalToConstant: 120),
                imageView.heightAnchor.constraint(equalToConstant: 120),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),

                votebutton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                votebutton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                votebutton.widthAnchor.constraint(equalToConstant: 80),
                votebutton.heightAnchor.constraint(equalToConstant: 30),
                votebutton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30)
                
            ])
        
        return cell
    }
    @objc func voteButtonPressed(_ sender: UIButton) {
        if let votingVC = self.storyboard?.instantiateViewController(withIdentifier: "VotingViewControllerID") as? VotingViewController {
            
            // Set any properties or data on the destination view controller
            if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
                votingVC.currtag = itinerary.tag
            }
            
            // Present the view controller
            self.present(votingVC, animated: true, completion: nil)
        } else {
            print("Error: VotingViewController not found")
        }
    }

    

    // Action when the day is changed from the segmented control
    @IBAction func dayChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
        reloadActivitiesForSelectedDay()
    }

    // Function to reload the activities for the selected day
    func reloadActivitiesForSelectedDay() {
        let selectedDay = tripTypeSegmentedControl.selectedSegmentIndex + 1
        activitiesForDisplay.removeAll()

        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            if let activitiesForSelectedDay = itinerary.activitiesforday[selectedDay], !activitiesForSelectedDay.isEmpty {
                // If there are activities for the selected day, set them for display
                activitiesForDisplay = activitiesForSelectedDay
                noActivitiesLabel.isHidden = true // Hide the label if activities are available
            } else {
                // Handle the case where there are no activities for this day
                activitiesForDisplay = []
                noActivitiesLabel.isHidden = false // Show the label if no activities are available
            }
        }

        tableView.reloadData() // Reload table view after updating the data
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editsegue" {
            if let destinationVC = segue.destination as? viewitineraryViewController {
                if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
                    destinationVC.currtag = itinerary.tag
                }
            }
        }
        if segue.identifier == "ShowVotingViewController",
           let destinationVC = segue.destination as? VotingViewController {
            if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
               destinationVC.currtag = itinerary.tag
                }
            }
        }
    
}





