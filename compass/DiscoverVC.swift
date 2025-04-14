//
//  DiscoverVC.swift
//  compass
//
//  Created by Katherine Chao on 4/10/25.
//

import UIKit
import Foundation

struct DiscoverItinerary {
    let title: String
    let imageName: String
}

class DiscoverVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var clickbutton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var tagtosend = 0
    
    let itineraries: [DiscoverItinerary] = [
        DiscoverItinerary(title: "Paris Girls' Trip", imageName: "paris"),
        DiscoverItinerary(title: "Surfing in Hawaii", imageName: "hawaii"),
        DiscoverItinerary(title: "Roman Holiday", imageName: "rome"),
        DiscoverItinerary(title: "Week in Tahoe", imageName: "tahoe"),
        DiscoverItinerary(title: "Historic Paris", imageName: "catacombs"),
        DiscoverItinerary(title: "Weekend in Vegas", imageName: "vegas"),
        DiscoverItinerary(title: "Best Cafes in Paris", imageName: "cafeparis"),
        DiscoverItinerary(title: "Foodies in Florence", imageName: "florence")
    ]
    
    func setUpItineraries() {
        let trip1 = Info(
            name: "Hawaii Family Reunion",
            flights: "UA123",
            stays: "Honolulu Hotel",
            numberOfDays: 5,
            startdate: "5/15/25",
            enddate: "5/20/25",
            imagename: "hawaii",
            activitiesforday: DataManager.shared.emptyActivities,
            activitiesforvoting: DataManager.shared.activities,
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
            activitiesforday: DataManager.shared.emptyActivities,
            activitiesforvoting: DataManager.shared.activities,
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
            activitiesforday: DataManager.shared.emptyActivities,
            activitiesforvoting: DataManager.shared.activities,
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
            activitiesforday: DataManager.shared.emptyActivities,
            activitiesforvoting: DataManager.shared.activities,
            tag: 4,
            numdays: 3,
            totalpeople: 12
        )
        
        DataManager.shared.discoverItineraries.append(trip1)
        DataManager.shared.discoverItineraries.append(trip2)
        DataManager.shared.discoverItineraries.append(trip3)
        DataManager.shared.discoverItineraries.append(trip4)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //need to fill itinerary or append to array of all itineraries
        view.bringSubviewToFront(clickbutton)
        setUpItineraries()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView.reloadData() //not sure if this line is needed or nah COME BACK
    }
    
    func configureLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            // Calculate cell size for 2 columns with padding
            let padding: CGFloat = 16
            let totalPadding: CGFloat = padding * 3 // left, middle, right padding
            let availableWidth = collectionView.frame.width - totalPadding
            let cellWidth = availableWidth / 2
                
            // Set cell size
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.2) // Adjust height ratio as needed
                
            // Set spacing
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
        
        // MARK: - UICollectionViewDataSource
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return DataManager.shared.discoverItineraries.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoverItineraryCell", for: indexPath) as? discoverItineraryCell else {
                // This error would appear if your cell isn't properly set up in the storyboard
                fatalError("Unable to dequeue discoverItineraryCell")
            }
            cell.isUserInteractionEnabled = true
            // Configure the cell with data
            let itinerary = DataManager.shared.discoverItineraries[indexPath.item]
            cell.configure(with: itinerary)
            tagtosend = DataManager.shared.discoverItineraries[indexPath.row].tag
            return cell
        }
        
        // MARK: - UICollectionViewDelegate
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // Handle cell selection - navigate to itinerary details
            let selectedItinerary = DataManager.shared.discoverItineraries[indexPath.item]
            tagtosend = selectedItinerary.tag
            print("Selected: \(selectedItinerary.name)")
            print("Cell selected at index: \(indexPath.item)") // FOR DEBUGGING
            // TODO: Navigate to detail screen
//            performSegue(withIdentifier: "discoverCellToViewSegue", sender: self)
        }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("Prepare for segue called with identifier: \(segue.identifier ?? "nil")") // DEBUGGING, DELETE LATER
//        if segue.identifier == "discoverCellToViewSegue" {
//            if let destinationVC = segue.destination as? viewitineraryViewController {
//                destinationVC.currtag = tagtosend
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "discovertoview" {
            if let destinationVC = segue.destination as? viewitineraryViewController {
                destinationVC.currtag = tagtosend
                destinationVC.numdays = 3
//                print(tagtosend)
            }
        }
    }

}
