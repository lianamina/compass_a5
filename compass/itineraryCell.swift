//
//  itineraryCell.swift
//  compass
//
//  Created by Katherine Chao on 3/31/25.
//

import UIKit

class itineraryCell: UICollectionViewCell {
    
    @IBOutlet weak var itineraryImageView: UIImageView!
    @IBOutlet weak var itineraryTitleLabel: UILabel!
    
    func configure(withTitle title: String, imageName: String) {
        itineraryTitleLabel.text = title
        if !imageName.isEmpty {
            itineraryImageView.image = UIImage(named: imageName)
        } else {
            itineraryImageView.image = UIImage(systemName: "photo") //placeholder if image doesnt work
        }
        // Make image smaller with rounded corners
               itineraryImageView.contentMode = .scaleAspectFill
               itineraryImageView.clipsToBounds = true
               itineraryImageView.layer.cornerRadius = 8
    }
}
