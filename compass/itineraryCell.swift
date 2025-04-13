////
////  itineraryCell.swift
////  compass
////
////  Created by Katherine Chao on 3/31/25.
////
//
//import UIKit
//
//class itineraryCell: UICollectionViewCell {
//    
////    @IBOutlet weak var itineraryTitleLabel: UILabel!
////    @IBOutlet weak var itineraryImageView: UIImageView!
//    
//    func configure(withTitle title: String, imageName: String) {
//        itineraryTitleLabel.text = title
//        if !imageName.isEmpty {
//            itineraryImageView.image = UIImage(named: imageName)
//        } else {
//            itineraryImageView.image = UIImage(systemName: "photo") //placeholder if image doesnt work
//        }
//        // Make image smaller with rounded corners
//        itineraryImageView.contentMode = .scaleAspectFill
//        itineraryImageView.clipsToBounds = true
//        itineraryImageView.layer.cornerRadius = 4
//        
//    }
//    
//    func configureAsCreateButton() {
//        itineraryTitleLabel.text = ""
//        itineraryTitleLabel.textAlignment = .center
//        itineraryTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
//        itineraryImageView.image = UIImage(systemName: "doc.badge.plus")
//        
//        itineraryImageView.tintColor = .darkGray
//        itineraryImageView.contentMode = .center
//
//        contentView.backgroundColor = UIColor.systemGray5
//        contentView.layer.cornerRadius = 8
//        
//    }
//}
