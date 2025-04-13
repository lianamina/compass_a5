//
//  discoverItineraryCell.swift
//  compass
//
//  Created by Katherine Chao on 4/13/25.
//

import UIKit

class discoverItineraryCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with itinerary: DiscoverItinerary) {
        bgImageView.image = UIImage(named: itinerary.imageName)
        titleLabel.text = itinerary.title
        
        // Add some styling
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.layer.cornerRadius = 12
        
        addGradientOverlay(to: bgImageView)
        
        titleLabel.textColor = UIColor.white
    }
    
    func addGradientOverlay(to imageView: UIImageView) {
        // Remove any existing gradient layers to prevent duplicates
        imageView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageView.bounds
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0) // Starts at the bottom
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)   // Fades up halfway
        gradientLayer.cornerRadius = imageView.layer.cornerRadius
        
        imageView.layer.addSublayer(gradientLayer)
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.frame = imageView.bounds
        gradientLayer2.colors = [
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer2.locations = [0.0, 1.0]
        gradientLayer2.startPoint = CGPoint(x: 0.5, y: 0) // Starts at the top
        gradientLayer2.endPoint = CGPoint(x: 0.5, y: 0.5)   // Fades down halfway
        gradientLayer2.cornerRadius = imageView.layer.cornerRadius
        
        imageView.layer.addSublayer(gradientLayer2)
    }
}

