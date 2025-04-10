//
//  EditEventVC.swift
//  compass
//
//  Created by Katherine Chao on 3/31/25.
//

import UIKit

// depending on if this is already made or a new one a nre tag needs to be made
// need a bool if new or not


class viewitineraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var flightInfo: String = ""
    var stayInfo: String = ""
    var eventTitle: String = ""
    var numdays = 0
    var activitiesForDisplay: [Activity] = []
    var currtag = 0;
    var noActivitiesLabel: UILabel!
    var underlineView: UIView!
    let textCellIdentifier = "TextCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        

        
        
        
        tableView.register(TimelineActivityCell.self, forCellReuseIdentifier: "TextCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        setupviews()
        populateinfo()

    }
    
    
    @IBOutlet weak var staylabel: UILabel!
    @IBOutlet weak var flightlabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    
    func generateDateStrings(startingFrom dateString: String, numdays: Int) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"

        let calendar = Calendar.current
        let baseDate = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 4))!

        return (0..<numdays).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: baseDate)!
            return dateFormatter.string(from: date)
        }
    }
    func setupviews() {
        noActivitiesLabel = UILabel()
        noActivitiesLabel.text = "No activities added for this day"
        noActivitiesLabel.textColor = .gray
        noActivitiesLabel.font = UIFont.systemFont(ofSize: 18)
        noActivitiesLabel.textAlignment = .center
        noActivitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        noActivitiesLabel.isHidden = true // Initially hidden
        view.addSubview(noActivitiesLabel)
        NSLayoutConstraint.activate([
            noActivitiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noActivitiesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noActivitiesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noActivitiesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let flightbackground = UIImageView(frame: self.view.bounds)
        flightbackground.image = UIImage(named: "backgroundsmall")
        flightbackground.contentMode = .scaleAspectFill
        flightbackground.clipsToBounds = true
        self.view.addSubview(flightbackground)
//        self.view.sendSubviewToBack(flightbackground)
        flightbackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flightbackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            flightbackground.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140),
            flightbackground.widthAnchor.constraint(equalToConstant: 172),
            flightbackground.heightAnchor.constraint(equalToConstant: 167),
        ])
        
        // stay backgound
        let staybackground = UIImageView(frame: self.view.bounds)
        staybackground.image = UIImage(named: "backgroundsmall")
        staybackground.contentMode = .scaleAspectFill
        staybackground.clipsToBounds = true
        self.view.addSubview(staybackground)
//        self.view.sendSubviewToBack(flightbackground)
        staybackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            staybackground.leadingAnchor.constraint(equalTo: flightbackground.trailingAnchor, constant: 10),
            staybackground.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140),
            staybackground.widthAnchor.constraint(equalToConstant: 172),
            staybackground.heightAnchor.constraint(equalToConstant: 167),
        ])
        
        
        

        
        let flightCard = UIView()
        flightCard.backgroundColor = .white
        flightCard.layer.cornerRadius = 16
        flightCard.layer.masksToBounds = true
        flightCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flightCard)

        NSLayoutConstraint.activate([
            flightCard.leadingAnchor.constraint(equalTo: flightbackground.leadingAnchor, constant: 7),
            flightCard.topAnchor.constraint(equalTo: flightbackground.topAnchor, constant: 50),
            flightCard.widthAnchor.constraint(equalToConstant: 160),
            flightCard.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Tag label
        let flightTag = UILabel()
        flightTag.text = "Flights"
        flightTag.font = UIFont.boldSystemFont(ofSize: 10)
        flightTag.textColor = .white
        flightTag.backgroundColor = UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.0)
        flightTag.layer.cornerRadius = 10
        flightTag.layer.masksToBounds = true
        flightTag.textAlignment = .center
        flightTag.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flightTag)

        NSLayoutConstraint.activate([
            flightTag.leadingAnchor.constraint(equalTo: flightCard.leadingAnchor, constant: 7),
            flightTag.topAnchor.constraint(equalTo: flightbackground.topAnchor, constant: 15),
            flightTag.widthAnchor.constraint(equalToConstant: 50),
            flightTag.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Confirmation info
        let flightConfirm = UILabel()
        flightConfirm.text = "Confirmation #     KPS43"
        flightConfirm.font = UIFont.systemFont(ofSize: 8)
        flightConfirm.textColor = .gray
        flightConfirm.translatesAutoresizingMaskIntoConstraints = false
        flightCard.addSubview(flightConfirm)

        // Airline
        let airlineLabel = UILabel()
        airlineLabel.text = "United Airlines"
        airlineLabel.font = UIFont.boldSystemFont(ofSize: 10)
        airlineLabel.translatesAutoresizingMaskIntoConstraints = false
        flightCard.addSubview(airlineLabel)

        let dateLabel = UILabel()
        dateLabel.text = "Thursday, July 14th"
        dateLabel.font = UIFont.systemFont(ofSize: 8)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        flightCard.addSubview(dateLabel)

        // Timeline dots and flight info
        let departureDot = UIView()
        departureDot.backgroundColor = .white
        departureDot.layer.borderColor = UIColor.systemGray4.cgColor
        departureDot.layer.borderWidth = 1
        departureDot.layer.cornerRadius = 4
        departureDot.translatesAutoresizingMaskIntoConstraints = false

        let arrivalDot = UIView()
        arrivalDot.backgroundColor = .white
        arrivalDot.layer.borderColor = UIColor.systemGray4.cgColor
        arrivalDot.layer.borderWidth = 1
        arrivalDot.layer.cornerRadius = 4
        arrivalDot.translatesAutoresizingMaskIntoConstraints = false

        let timelineLine = UIView()
        timelineLine.backgroundColor = .systemGray4
        timelineLine.translatesAutoresizingMaskIntoConstraints = false

        let sfoLabel = UILabel()
        sfoLabel.text = "SFO"
        sfoLabel.font = UIFont.boldSystemFont(ofSize: 12)
        sfoLabel.translatesAutoresizingMaskIntoConstraints = false

        let sfoTime = UILabel()
        sfoTime.text = "11:32 AM"
        sfoTime.font = UIFont.systemFont(ofSize: 10)
        sfoTime.translatesAutoresizingMaskIntoConstraints = false

        let cdgLabel = UILabel()
        cdgLabel.text = "CDG"
        cdgLabel.font = UIFont.boldSystemFont(ofSize: 12)
        cdgLabel.translatesAutoresizingMaskIntoConstraints = false

        let cdgTime = UILabel()
        cdgTime.text = "5:32 PM"
        cdgTime.font = UIFont.systemFont(ofSize: 10)
        cdgTime.translatesAutoresizingMaskIntoConstraints = false

        let flightChevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        flightChevron.tintColor = .black
        flightChevron.translatesAutoresizingMaskIntoConstraints = false

        [departureDot, arrivalDot, timelineLine, sfoLabel, sfoTime, cdgLabel, cdgTime, flightChevron].forEach {
            flightCard.addSubview($0)
        }

        NSLayoutConstraint.activate([
            flightConfirm.topAnchor.constraint(equalTo: flightCard.topAnchor, constant: 9),
            flightConfirm.leadingAnchor.constraint(equalTo: flightCard.leadingAnchor, constant: 8),

            airlineLabel.topAnchor.constraint(equalTo: flightConfirm.bottomAnchor, constant: 2),
            airlineLabel.leadingAnchor.constraint(equalTo: flightCard.leadingAnchor, constant: 8),

            dateLabel.topAnchor.constraint(equalTo: airlineLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: flightCard.leadingAnchor, constant: 8),

            departureDot.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            departureDot.leadingAnchor.constraint(equalTo: flightCard.leadingAnchor, constant: 10),
            departureDot.widthAnchor.constraint(equalToConstant: 8),
            departureDot.heightAnchor.constraint(equalToConstant: 8),

            arrivalDot.topAnchor.constraint(equalTo: departureDot.bottomAnchor, constant: 20),
            arrivalDot.leadingAnchor.constraint(equalTo: departureDot.leadingAnchor),
            arrivalDot.widthAnchor.constraint(equalToConstant: 8),
            arrivalDot.heightAnchor.constraint(equalToConstant: 8),

            timelineLine.centerXAnchor.constraint(equalTo: departureDot.centerXAnchor),
            timelineLine.topAnchor.constraint(equalTo: departureDot.bottomAnchor),
            timelineLine.bottomAnchor.constraint(equalTo: arrivalDot.topAnchor),
            timelineLine.widthAnchor.constraint(equalToConstant: 1),

            sfoLabel.centerYAnchor.constraint(equalTo: departureDot.centerYAnchor),
            sfoLabel.leadingAnchor.constraint(equalTo: departureDot.trailingAnchor, constant: 10),

            sfoTime.centerYAnchor.constraint(equalTo: departureDot.centerYAnchor),
            sfoTime.leadingAnchor.constraint(equalTo: sfoLabel.trailingAnchor, constant: 8),

            cdgLabel.centerYAnchor.constraint(equalTo: arrivalDot.centerYAnchor),
            cdgLabel.leadingAnchor.constraint(equalTo: arrivalDot.trailingAnchor, constant: 10),

            cdgTime.centerYAnchor.constraint(equalTo: arrivalDot.centerYAnchor),
            cdgTime.leadingAnchor.constraint(equalTo: cdgLabel.trailingAnchor, constant: 8),

            flightChevron.centerYAnchor.constraint(equalTo: cdgLabel.centerYAnchor),
            flightChevron.trailingAnchor.constraint(equalTo: flightCard.trailingAnchor, constant: -8),
            flightChevron.widthAnchor.constraint(equalToConstant: 8),
            flightChevron.heightAnchor.constraint(equalToConstant: 8)
        ])

        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.trailingAnchor.constraint(equalTo: staybackground.trailingAnchor, constant: -7),
            cardView.topAnchor.constraint(equalTo: staybackground.topAnchor, constant: 50),
            cardView.widthAnchor.constraint(equalToConstant: 160),
            cardView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
        // "Stays" tag
        let tagLabel = UILabel()
        tagLabel.text = "Stays"
        tagLabel.font = UIFont.boldSystemFont(ofSize: 10)
        tagLabel.textColor = .white
        tagLabel.backgroundColor = UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.0)
        tagLabel.layer.cornerRadius = 10
        tagLabel.layer.masksToBounds = true
        tagLabel.textAlignment = .center
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagLabel)

        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: staybackground.topAnchor, constant: 15),
            tagLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            tagLabel.widthAnchor.constraint(equalToConstant: 50),
            tagLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Confirmation row
        let confirmLabel = UILabel()
        confirmLabel.text = "Confirmation #     " + (staylabel.text ?? "")
        confirmLabel.font = UIFont.systemFont(ofSize: 8)
        confirmLabel.textColor = .gray
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(confirmLabel)

        // Title row
        let titleLabel = UILabel()
        titleLabel.text = "Condo in Les Halles"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 11)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        let dateLabelforstay = UILabel()
        dateLabelforstay.text = "07/14 - 07/18"
        dateLabelforstay.font = UIFont.systemFont(ofSize: 8)
        dateLabelforstay.textColor = .gray
        dateLabelforstay.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dateLabelforstay)

        // Location row
        let locationIcon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        locationIcon.tintColor = .gray
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(locationIcon)

        let locationLabel = UILabel()
        locationLabel.text = "75001 Paris Châtelet"
        locationLabel.font = UIFont.systemFont(ofSize: 8)
        locationLabel.textColor = .gray
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(locationLabel)

        // Amenities row
        let bedIcon = UIImageView(image: UIImage(systemName: "bed.double"))
        bedIcon.tintColor = .black
        bedIcon.translatesAutoresizingMaskIntoConstraints = false

        let bedCount = UILabel()
        bedCount.text = "2"
        bedCount.font = UIFont.systemFont(ofSize: 8)
        bedCount.translatesAutoresizingMaskIntoConstraints = false

        let bathIcon = UIImageView(image: UIImage(systemName: "shower"))
        bathIcon.tintColor = .black
        bathIcon.translatesAutoresizingMaskIntoConstraints = false

        let bathCount = UILabel()
        bathCount.text = "1"
        bathCount.font = UIFont.systemFont(ofSize: 8)
        bathCount.translatesAutoresizingMaskIntoConstraints = false

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .black
        chevron.translatesAutoresizingMaskIntoConstraints = false

        [bedIcon, bedCount, bathIcon, bathCount, chevron].forEach {
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            confirmLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 9),
            confirmLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),

            titleLabel.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),

            dateLabelforstay.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabelforstay.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),

            locationIcon.topAnchor.constraint(equalTo: dateLabelforstay.bottomAnchor, constant: 6),
            locationIcon.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            locationIcon.widthAnchor.constraint(equalToConstant: 10),
            locationIcon.heightAnchor.constraint(equalToConstant: 10),

            locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 4),

            bedIcon.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            bedIcon.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            bedIcon.widthAnchor.constraint(equalToConstant: 10),
            bedIcon.heightAnchor.constraint(equalToConstant: 10),

            bedCount.centerYAnchor.constraint(equalTo: bedIcon.centerYAnchor),
            bedCount.leadingAnchor.constraint(equalTo: bedIcon.trailingAnchor, constant: 3),

            bathIcon.centerYAnchor.constraint(equalTo: bedIcon.centerYAnchor),
            bathIcon.leadingAnchor.constraint(equalTo: bedCount.trailingAnchor, constant: 12),
            bathIcon.widthAnchor.constraint(equalToConstant: 10),
            bathIcon.heightAnchor.constraint(equalToConstant: 10),

            bathCount.centerYAnchor.constraint(equalTo: bathIcon.centerYAnchor),
            bathCount.leadingAnchor.constraint(equalTo: bathIcon.trailingAnchor, constant: 3),

            chevron.centerYAnchor.constraint(equalTo: bathCount.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            chevron.widthAnchor.constraint(equalToConstant: 8),
            chevron.heightAnchor.constraint(equalToConstant: 8)
        ])


    }
    

    
    func populateinfo() {
        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            print(currtag)
            titlelabel.text = itinerary.name
            staylabel.text = itinerary.stays
            flightlabel.text = itinerary.flights
            numdays = itinerary.numdays
            allActivities = itinerary.activitiesforday
        }

        // Generate segment titles and dates
        let titles = (1...numdays).map { "Day \($0)" }
        let dates = generateDateStrings(startingFrom: "Apr 4", numdays: numdays) // Helper method from before

        // Create custom tab view
        let customTabs = CustomSegmentedControl(titles: titles, dates: dates)
        customTabs.translatesAutoresizingMaskIntoConstraints = false

        customTabs.onSelectionChanged = { index in
            self.reloadActivitiesForSelectedDay(selectedIndex: index)
        }

        view.addSubview(customTabs)

        NSLayoutConstraint.activate([
            customTabs.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 260),
            customTabs.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTabs.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTabs.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Set initial state
        reloadActivitiesForSelectedDay(selectedIndex: 0)
    }

    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesForDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! TimelineActivityCell

        let activity = activitiesForDisplay[indexPath.row]
        
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == activitiesForDisplay.count - 1
        let state: TimelineActivityCell.TimelineState = isFirst ? .highlighted : .normal
        
        cell.configureTimelinePosition(isFirst: isFirst, isLast: isLast, state: state)
            // Title label
            let titleLabel = UILabel()
            titleLabel.text = activity.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.backgroundColor = UIColor.white
            cell.contentView.addSubview(titleLabel)
            
            // Image View
            let imageView = UIImageView()
            imageView.image = activity.picture  // Replace with your image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(imageView)
        
            var votebutton: UIButton
            if let existingButton = cell.contentView.viewWithTag(100) as? UIButton {
                votebutton = existingButton
            } else {
                // Create a new button if it doesn't exist
                votebutton = UIButton(type: .system)
                votebutton.setTitle("Vote", for: .normal)
                votebutton.setTitleColor(.white, for: .normal)
                votebutton.backgroundColor = UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.00)
                votebutton.layer.cornerRadius = 8
                votebutton.tag = 100 // Assign a tag to identify the button
                votebutton.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(votebutton)
            }
            votebutton.addTarget(self, action: #selector(voteButtonPressed(_:)), for: .touchUpInside)
            // Set the visibility of the button based on the didvote property
            votebutton.isHidden = activity.didvote
            
            
            NSLayoutConstraint.activate([
                // Title label constraints
                titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 50),
                titleLabel.widthAnchor.constraint(equalToConstant: 500),
                titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
//                titleLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),
                // Image view constraints (right side)
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                imageView.widthAnchor.constraint(equalToConstant: 120),
                imageView.heightAnchor.constraint(equalToConstant: 120),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),

                votebutton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                votebutton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                votebutton.widthAnchor.constraint(equalToConstant: 80),
                votebutton.heightAnchor.constraint(equalToConstant: 30),
                votebutton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30)
                
            ])
        
        
        return cell
    }

    
    
    @objc func voteButtonPressed(_ sender: UIButton) {
        if let votingVC = self.storyboard?.instantiateViewController(withIdentifier: "VotingViewControllerID") as? VotingViewController {
            
            // Set any properties or data on the destination view controller
            if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
                votingVC.currtag = itinerary.tag
            }
            
            // Present the view controller
            self.present(votingVC, animated: true, completion: nil)
        } else {
            print("Error: VotingViewController not found")
        }
    }

    
    // Function to reload the activities for the selected day
    func reloadActivitiesForSelectedDay(selectedIndex: Int) {
        let selectedDay = selectedIndex + 1 // Because day keys are 1-based
        activitiesForDisplay.removeAll()

        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            if let activitiesForSelectedDay = itinerary.activitiesforday[selectedDay], !activitiesForSelectedDay.isEmpty {
                activitiesForDisplay = activitiesForSelectedDay
                noActivitiesLabel.isHidden = true
            } else {
                activitiesForDisplay = []
                noActivitiesLabel.isHidden = false
            }
        }

        tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editsegue" {
            print("Preparing for editsegue")  // Debugging print
            if let destinationVC = segue.destination as? EditEventVC {
                destinationVC.currtag = self.currtag
                print("Passing currtag: \(self.currtag) to EditEventVC")  // Debugging print
            }
        }
        if segue.identifier == "ShowVotingViewController",
           let destinationVC = segue.destination as? VotingViewController {
            if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
               destinationVC.currtag = currtag
                }
            }
        }
    
}




// for asthetic

class TimelineActivityCell: UITableViewCell {
    
    let circleView = UIView()
    let lineAbove = UIView()
    let lineBelow = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTimelineViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTimelineViews()
    }

    private func setupTimelineViews() {
        [circleView, lineAbove, lineBelow].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        // Style
        circleView.layer.cornerRadius = 12
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.systemGray4.cgColor

        lineAbove.backgroundColor = .systemGray4
        lineBelow.backgroundColor = .systemGray4

        NSLayoutConstraint.activate([
            // Circle
            circleView.widthAnchor.constraint(equalToConstant: 22),
            circleView.heightAnchor.constraint(equalToConstant: 22),
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // Line above
            lineAbove.widthAnchor.constraint(equalToConstant: 2),
            lineAbove.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            lineAbove.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineAbove.bottomAnchor.constraint(equalTo: circleView.topAnchor),

            // Line below
            lineBelow.widthAnchor.constraint(equalToConstant: 2),
            lineBelow.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            lineBelow.topAnchor.constraint(equalTo: circleView.bottomAnchor),
            lineBelow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    enum TimelineState {
        case highlighted
        case normal
    }

    func configureTimelinePosition(isFirst: Bool, isLast: Bool, state: TimelineState) {
        lineAbove.isHidden = isFirst
        lineBelow.isHidden = isLast

        switch state {
        case .highlighted:
            circleView.backgroundColor = UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.00)
            lineAbove.backgroundColor = UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.00)
            lineBelow.backgroundColor = UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.00)
        case .normal:
            circleView.backgroundColor = .white
            lineAbove.backgroundColor = .systemGray4
            lineBelow.backgroundColor = .systemGray4
        }
    }
}


class CustomSegmentedControl: UIView {

    var segmentTitles: [String] = []
    var segmentDates: [String] = []
    var buttons: [UIButton] = []
    var selectedIndex: Int = 0 {
        didSet {
            updateButtonColorsOnly()
            layoutUnderline(animated: true)
        }
    }
    var underlineView = UIView()
    var onSelectionChanged: ((Int) -> Void)?

    init(titles: [String], dates: [String]) {
        self.segmentTitles = titles
        self.segmentDates = dates
        super.init(frame: .zero)
        setupView()
        DispatchQueue.main.async {
            self.updateButtonTitles()
            self.layoutUnderline(animated: false)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for i in 0..<segmentTitles.count {
            let button = UIButton(type: .system)
            button.tag = i
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)

            buttons.append(button)
            stackView.addArrangedSubview(button)
        }

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Add underline view
        underlineView.backgroundColor = UIColor.systemOrange
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlineView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutUnderline(animated: false)
    }

    private func layoutUnderline(animated: Bool) {
        guard buttons.indices.contains(selectedIndex) else { return }
        let selectedButton = buttons[selectedIndex]
        let underlineHeight: CGFloat = 3.0

        let targetFrame = CGRect(
            x: selectedButton.frame.origin.x,
            y: frame.height - underlineHeight,
            width: selectedButton.frame.width,
            height: underlineHeight)

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.underlineView.frame = targetFrame
            }
        } else {
            underlineView.frame = targetFrame
        }
    }

    private func updateButtonTitles() {
        for (i, button) in buttons.enumerated() {
            let title = segmentTitles[i]
            let date = segmentDates[i]

            let attributedText = NSMutableAttributedString(
                string: "\(title)\n",
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 14),
                    .foregroundColor: (i == selectedIndex ? UIColor.systemOrange : UIColor.gray)
                ])
            attributedText.append(NSAttributedString(
                string: date,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.gray
                ]))

            button.setAttributedTitle(attributedText, for: .normal)
        }
    }

    private func updateButtonColorsOnly() {
        for (i, button) in buttons.enumerated() {
            let title = segmentTitles[i]
            let date = segmentDates[i]

            let attributedText = NSMutableAttributedString(
                string: "\(title)\n",
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 14),
                    .foregroundColor: (i == selectedIndex ? UIColor.systemOrange : UIColor.gray)
                ])
            attributedText.append(NSAttributedString(
                string: date,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.gray
                ]))

            button.setAttributedTitle(attributedText, for: .normal)
        }
    }


    @objc func segmentTapped(_ sender: UIButton) {
        guard sender.tag != selectedIndex else { return }
        selectedIndex = sender.tag
        onSelectionChanged?(selectedIndex)
    }
}
