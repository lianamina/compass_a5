//
//  ViewController.swift
//  compass
//
//  Created by Denise Ramos on 3/25/25.
//

import UIKit

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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Configure horizontal layout
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth/4 //4 items per row
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth+40) // Adjust size as needed
            layout.minimumLineSpacing = 16
            
            collectionView.collectionViewLayout = layout
        
        self.collectionView.reloadData()
    }
    
    let featuredItineraries = [ Itinerary(title: "Paris Girls' Trip", startDate: "", endDate: "", imageName: "paris"),
        Itinerary(title: "Surf in Sagres", startDate: "", endDate: "", imageName: "florence"),
        Itinerary(title: "Spanish Siesta", startDate: "", endDate: "", imageName: "catacombs"),
        Itinerary(title: "Week in Tokyo", startDate: "", endDate: "", imageName: "glass")
                            
    ]
    
    let allItineraries = [ Itinerary(title: "Hawaii Family Reunion", startDate: "5/15/25", endDate: "5/20/25", imageName: ""),
        Itinerary(title: "Grand Canyon Road Trip", startDate: "6/1/25", endDate: "6/8/25", imageName: ""),
        Itinerary(title: "Lake Tahoe Trip", startDate: "7/13/25", endDate: "7/21/25", imageName: ""),
        Itinerary(title: "Italian Summer", startDate: "8/3/25", endDate: "8/17/25", imageName: "")
    ]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return featuredItineraries.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itineraryCell", for: indexPath) as! itineraryCell
            
        let itinerary = featuredItineraries[indexPath.row]
            // Configure cell for an itinerary
         cell.configure(withTitle: itinerary.title, imageName: itinerary.imageName)
            return cell
        }
    



}

