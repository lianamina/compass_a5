//
//  EditEventVC.swift
//  compass
//
//  Created by Katherine Chao on 3/31/25.
//

import UIKit

// depending on if this is already made or a new one a nre tag needs to be made
// need a bool if new or not
var itineraryTagg = 1
class EditEventVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var flightInfo: String = ""
    var stayInfo: String = ""
    var eventTitle: String = ""
    let textCellIdentifier = "TextCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        populateinfo()
    }
    
    func populateinfo() {
        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == itineraryTagg }) {
            titleTextField.text = itinerary.name
            stayTextField.text = itinerary.stays
            flightTextField.text = itinerary.flights
        }
        let tripTypes = ["Day 1"]
            tripTypeSegmentedControl.removeAllSegments()
            
            for (index, type) in tripTypes.enumerated() {
                tripTypeSegmentedControl.insertSegment(withTitle: type, at: index, animated: false)
            }
            
            tripTypeSegmentedControl.selectedSegmentIndex = 0

    }
    
    @IBOutlet weak var tripTypeSegmentedControl: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allActivities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let activity = allActivities[indexPath.row]

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = activity.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(titleLabel)

        // Image View
        let imageView = UIImageView()
        imageView.image = activity.picture  // Replace with your image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(imageView)
        

        // total votes label

        // Apply Constraints
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),

            // Image view constraints (right side)
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120)

        ])

        return cell
    }

    @IBOutlet weak var titleTextField: UITextField!
    

    @IBOutlet weak var stayTextField: UITextField!
    
    @IBOutlet weak var flightTextField: UITextField!
    

    @IBAction func addday(_ sender: Any) {
        
        tripTypeSegmentedControl.insertSegment(withTitle: "Day 1", at: 1, animated: false)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        flightInfo = flightTextField.text ?? ""
        stayInfo = stayTextField.text ?? ""
        eventTitle = titleTextField.text ?? ""
        
        
//        performSegue(withIdentifier: "viewpagesegue", sender: self)

        print("Flight: \(flightInfo), Stay: \(stayInfo), Title: \(eventTitle)")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "viewpagesegue" {
//            if segue.destination is viewitineraryViewController {
//                
//            }
//        }
//    }
}




