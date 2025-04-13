//
//  DiscoverVC.swift
//  compass
//
//  Created by Katherine Chao on 4/10/25.
//

import UIKit

struct DiscoverItinerary {
    let title: String
    let imageName: String
}

class DiscoverVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //need to fill itinerary or append to array of all itineraries
        
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
            return itineraries.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoverItineraryCell", for: indexPath) as? discoverItineraryCell else {
                // This error would appear if your cell isn't properly set up in the storyboard
                fatalError("Unable to dequeue discoverItineraryCell")
            }
            
            // Configure the cell with data
            let itinerary = itineraries[indexPath.item]
            cell.configure(with: itinerary)
            
            return cell
        }
        
        // MARK: - UICollectionViewDelegate
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // Handle cell selection - navigate to itinerary details
            let selectedItinerary = itineraries[indexPath.item]
            print("Selected: \(selectedItinerary.title)")
            
            // TODO: Navigate to detail screen
        }
    
}
