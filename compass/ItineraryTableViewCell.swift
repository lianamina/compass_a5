//
//  ItineraryTableViewCell.swift
//  compass
//
//  Created by Katherine Chao on 4/1/25.
//

import UIKit

class ItineraryTableViewCell: UITableViewCell {
    

    @IBOutlet weak var itineraryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with itinerary: Info) {
        titleLabel.text = itinerary.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        
        dateLabel.text = "\(itinerary.startdate) - \(itinerary.enddate)"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.numberOfLines = 1
        
        if !itinerary.imageName.isEmpty {
            itineraryImageView.image = UIImage(named: itinerary.imageName)
                } else {
                    itineraryImageView.image = UIImage(systemName: "photo") // Placeholder image
                }
        itineraryImageView.contentMode = .scaleAspectFill
        itineraryImageView.clipsToBounds = true
        itineraryImageView.layer.cornerRadius = 4
        itineraryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Disable autoresizing masks (required for Auto Layout)
        itineraryImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and activate constraints
        NSLayoutConstraint.activate([
            // Image view constraints - right side with fixed size
            itineraryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            itineraryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itineraryImageView.widthAnchor.constraint(equalToConstant: 100),
            itineraryImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title label constraints - top and left with padding
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: itineraryImageView.leadingAnchor, constant: -16),
            
            // Dates label constraints - below title with same leading edge
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    
}

