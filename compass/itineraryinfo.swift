//
//  itineraryinfo.swift
//  compass
//
//  Created by Denise Ramos on 4/7/25.
//

import UIKit

// MARK: - Info Class
class Info {
    var name: String
    var flights: String
    var stays: String
    var numberOfDays: Int
    var startdate: String
    var enddate: String
    var imageName: String
    var activities: [Int: [Activity]]
    var tag: Int
    var numdays: Int
    
    init(name: String, flights: String, stays: String, numberOfDays: Int, startdate: String, enddate: String, imagename: String, activities: [Int: [Activity]], tag: Int, numdays: Int) {
        self.name = name
        self.flights = flights
        self.stays = stays
        self.numberOfDays = numberOfDays
        self.startdate = startdate
        self.enddate = enddate
        self.imageName = imagename
        self.activities = activities
        self.tag = tag
        self.numdays = numdays

    }
}

// MARK: - Activities Class
class Activity {
    var title: String
    var currentTime: Double
    var picture: UIImage
    var yesVotes: Int
    var noVotes: Int
    
    init(title: String, currentTime: Double, picture: UIImage, yesVotes: Int = 0, noVotes: Int = 0) {
        self.title = title
        self.currentTime = currentTime
        self.picture = picture
        self.yesVotes = yesVotes
        self.noVotes = noVotes
    }
}

class DataManager {
    static let shared = DataManager()
    
    private init() { }
    
    var allItineraries: [Info] = []
    var activities: [Activity] = []
}


