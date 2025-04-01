//
//  ViewController.swift
//  compass
//
//  Created by Denise Ramos on 3/25/25.
//

import UIKit

protocol ItineraryCreationDelegate: AnyObject {
    func didCreateNewItinerary(_ itinerary: Itinerary)
}

struct Itinerary: Hashable {
    let title: String
    let startDate: String
    let endDate: String
    let imageName: String
    
    init(title: String, startDate: String, endDate: String, imageName: String) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.imageName = imageName
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ItineraryCreationDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
   
        tableView.dataSource = self
        tableView.delegate = self
        
        // Enable dynamic row sizing
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        tableView.beginUpdates()
        tableView.endUpdates()

        // Add some extra padding
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            
        // Add light separator
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        
        // Configure horizontal layout
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth/4 //4 items per row
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth+40) // Adjust size as needed
            layout.minimumLineSpacing = 16
            
            collectionView.collectionViewLayout = layout
        
        self.collectionView.reloadData()
        tableView.reloadData()
    }
    
    func didCreateNewItinerary(_ itinerary: Itinerary) {
        featuredItineraries.append(itinerary)
        //potentially append to allItineraries too
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itinCellToEditEventVC" {
            if let editVC = segue.destination as? EditEventVC {
                editVC.delegate = self
            }
        }
    }
    
    var featuredItineraries = [
        nil, //for create new itinerary button
        Itinerary(title: "Paris Girls' Trip", startDate: "", endDate: "", imageName: "arc"),
        Itinerary(title: "Surf in Sagres", startDate: "", endDate: "", imageName: "eiffel"),
        Itinerary(title: "Spanish Siesta", startDate: "", endDate: "", imageName: "catacombs"),
        Itinerary(title: "Week in Tokyo", startDate: "", endDate: "", imageName: "glass")
    ]
    
    var allItineraries = [ Itinerary(title: "Hawaii Family Reunion", startDate: "5/15/25", endDate: "5/20/25", imageName: "hawaii"),
        Itinerary(title: "Bachelorette in Vegas", startDate: "6/1/25", endDate: "6/8/25", imageName: "vegas"),
        Itinerary(title: "Lake Tahoe Trip", startDate: "7/13/25", endDate: "7/21/25", imageName: "tahoe"),
        Itinerary(title: "Italian Summer", startDate: "8/3/25", endDate: "8/17/25", imageName: "rome")
    ]
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 { // Assuming first item is the "+" button
            performSegue(withIdentifier: "itinCellToEditEventVC", sender: self)
        }
//        } else {
//            // Handle regular itinerary selection
//            let selectedItinerary = featuredItineraries[indexPath.row - 1] // Offset by 1 due to "+" button
//            // Navigate to itinerary details or other action
//        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return featuredItineraries.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itineraryCell", for: indexPath) as! itineraryCell
        
        if let itinerary = featuredItineraries[indexPath.row] {
            // Configure cell for an itinerary
            cell.configure(withTitle: itinerary.title, imageName: itinerary.imageName)
        } else {
            cell.configureAsCreateButton()
        }
        
        return cell
    }
    
    
    // TABLE VIEW FUNCTIONS START BELOW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allItineraries.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itinTableViewCell", for: indexPath) as! ItineraryTableViewCell
            
            let itinerary = allItineraries[indexPath.row]
            cell.configure(with: itinerary)
            
            return cell
        }
    
    //come back to this
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedItinerary = allItineraries[indexPath.row]
        
            // Navigate to a detailed view if needed
        }
}

