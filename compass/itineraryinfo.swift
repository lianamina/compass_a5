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
    var activitiesforday: [Int: [Activity]]
    var activitiesforvoting: [Activity]
    var tag: Int
    var numdays: Int
    var totalpeople: Int
    
    init(name: String, flights: String, stays: String, numberOfDays: Int, startdate: String, enddate: String, imagename: String, activitiesforday: [Int: [Activity]], activitiesforvoting: [Activity], tag: Int, numdays: Int, totalpeople: Int) {
        self.name = name
        self.flights = flights
        self.stays = stays
        self.numberOfDays = numberOfDays
        self.startdate = startdate
        self.enddate = enddate
        self.imageName = imagename
        self.activitiesforday = activitiesforday
        self.activitiesforvoting = activitiesforvoting
        self.tag = tag
        self.numdays = numdays
        self.totalpeople = totalpeople

    }
}

// MARK: - Activities Class
class Activity {
    var title: String
    var currentTime: Double
    var picture: UIImage
    var yesVotes: Int
    var noVotes: Int
    var didvote: Bool
    var notes: String
    
    init(title: String, currentTime: Double, picture: UIImage, yesVotes: Int = 0, noVotes: Int = 0, didvote: Bool = false, notes: String = "") {
        self.title = title
        self.currentTime = currentTime
        self.picture = picture
        self.yesVotes = yesVotes
        self.noVotes = noVotes
        self.didvote = didvote
        self.notes = notes
    }
}

class DataManager {
    static let shared = DataManager()
    
    private init() { }
    
    var allItineraries: [Info] = []
    var activities: [Activity] = []
}


