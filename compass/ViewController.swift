//
//  ViewController.swift
//  compass
//
//  Created by Denise Ramos on 3/25/25.
//

import UIKit
import Foundation

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

class ViewController: UIViewController,  ItineraryCreationDelegate, UITableViewDataSource, UITableViewDelegate {
    
//    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    var tagtosend = 0
    var currnumdays = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        // hello
        let activity1 = Activity(title: "Louvre", currentTime: 86400, picture: UIImage(named: "louvre")!, yesVotes: 6, noVotes: 4, didvote: true, notes: "this is my note", time: timeIntervalFromString("10 AM") ?? 0)
        let activity2 = Activity(title: "Eiffel Tower", currentTime: 86400, picture: UIImage(named: "eiffel")!, yesVotes: 7, noVotes: 3, didvote: false, notes: "this is mt note pt 2 and what is it is really lond ang the contraints cannot hold it and there is a lot of text becasue denise really wants to go to the louvre", time: timeIntervalFromString("7 AM") ?? 0)

        let trip1 = Info(
            name: "Hawaii Family Reunion",
            flights: "UA123",
            stays: "Hotel Les Halles",
            numberOfDays: 5,
            startdate: "5/15/25",
            enddate: "5/20/25",
            imagename: "hawaii",
            activitiesforday: [1: [activity1], 2: [activity2]],
            activitiesforvoting: [activity1, activity2],
            tag: 1,
            numdays: 5,
            totalpeople: 12
        )
        let trip2 = Info(
            name: "Bachelorette in Vegas",
            flights: "UA123",
            stays: "Hotel Les Halles",
            numberOfDays: 3,
            startdate: "6/1/25",
            enddate: "6/8/25",
            imagename: "vegas",
            activitiesforday: [1: [activity1, activity2]],
            activitiesforvoting: [activity1, activity2],
            tag: 2,
            numdays: 3,
            totalpeople: 20
        )
        
        let trip3 = Info(
            name: "Lake Tahoe Trip",
            flights: "UA123",
            stays: "Hotel Les Halles",
            numberOfDays: 3,
            startdate: "7/13/25",
            enddate: "7/21/25",
            imagename: "tahoe",
            activitiesforday: [1: [activity1, activity2]],
            activitiesforvoting: [activity1, activity2],
            tag: 3,
            numdays: 3,
            totalpeople: 12
        )
        let trip4 = Info(
            name: "Italian Summer",
            flights: "UA123",
            stays: "Hotel Les Halles",
            numberOfDays: 3,
            startdate: "8/3/25",
            enddate: "8/17/25",
            imagename: "rome",
            activitiesforday: [1: [activity1, activity2]],
            activitiesforvoting: [activity1, activity2],
            tag: 4,
            numdays: 3,
            totalpeople: 12
        )

        DataManager.shared.allItineraries.append(trip1)
        DataManager.shared.allItineraries.append(trip2)
        DataManager.shared.allItineraries.append(trip3)
        DataManager.shared.allItineraries.append(trip4)

        
        // Do any additional setup after loading the view.
//        collectionView.dataSource = self
//        collectionView.delegate = self
   
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
        
        
        // Configure horizontal layout COLLECTION VIEW
//            let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .horizontal
//        
//        let screenWidth = UIScreen.main.bounds.width
//        let itemWidth = screenWidth/4 //4 items per row
//            layout.itemSize = CGSize(width: itemWidth, height: itemWidth+40) // Adjust size as needed
//            layout.minimumLineSpacing = 16
//            
//            collectionView.collectionViewLayout = layout
//        
//        self.collectionView.reloadData()
        tableView.reloadData()
    }
    
    func didCreateNewItinerary(_ itinerary: Itinerary) {
        featuredItineraries.append(itinerary)
        //potentially append to allItineraries too
//        collectionView.reloadData()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "itinCellToEditEventVC" {
//            if let editVC = segue.destination as? EditEventVC {
//                editVC.delegate = self
//            }
//        }
//    }
    func timeIntervalFromString(_ timeString: String) -> TimeInterval? {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // handles "9 AM", "5 PM", etc.
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current

        guard let parsedTime = formatter.date(from: timeString.uppercased()) else {
            return nil
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        return parsedTime.timeIntervalSince(startOfDay)
    }





    var featuredItineraries = [
        nil, //for create new itinerary button
        Itinerary(title: "Paris Girls' Trip", startDate: "", endDate: "", imageName: "arc"),
        Itinerary(title: "Surf in Sagres", startDate: "", endDate: "", imageName: "eiffel"),
        Itinerary(title: "Spanish Siesta", startDate: "", endDate: "", imageName: "catacombs"),
        Itinerary(title: "Week in Tokyo", startDate: "", endDate: "", imageName: "glass")
    ]
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 { // Assuming first item is the "+" button
//            performSegue(withIdentifier: "itinCellToEditEventVC", sender: self)
//        }
//    }

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return featuredItineraries.count
//        }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itineraryCell", for: indexPath) as! itineraryCell
//        
//        if let itinerary = featuredItineraries[indexPath.row] {
//            // Configure cell for an itinerary
//            cell.configure(withTitle: itinerary.title, imageName: itinerary.imageName)
//        } else {
//            cell.configureAsCreateButton()
//        }
//        
//        return cell
//    }
    
    
    // TABLE VIEW FUNCTIONS START BELOW
//    DataManager.shared.trips
//    DataManager.shared.activities

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.allItineraries.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itinTableViewCell", for: indexPath) as! ItineraryTableViewCell
            
            let itinerary = DataManager.shared.allItineraries[indexPath.row]
            cell.configure(with: itinerary)
            tagtosend = DataManager.shared.allItineraries[indexPath.row].tag
            print(tagtosend)
            return cell
        }
    
    //come back to this
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItinerary = DataManager.shared.allItineraries[indexPath.row]
        tagtosend = selectedItinerary.tag
        currnumdays = selectedItinerary.numberOfDays
        performSegue(withIdentifier: "viewpagesegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewpagesegue" {
            if let destinationVC = segue.destination as? viewitineraryViewController {
                destinationVC.currtag = tagtosend
                destinationVC.numdays = currnumdays
                print(tagtosend)
            }
        }
    }

}

