//
//  EditEventVC.swift
//  compass
//
//  Created by Katherine Chao on 3/31/25.
//

import UIKit

// depending on if this is already made or a new one a nre tag needs to be made
// need a bool if new or not
protocol VotingViewControllerDelegate: AnyObject {
    func didUpdateVotes(for tag: Int, updatedActivities: [Activity])
}

extension viewitineraryViewController: VotingViewControllerDelegate {
    func didUpdateVotes(for tag: Int, updatedActivities: [Activity]) {
        // Update your local data (maybe reload a table or refresh visuals)
        if let index = DataManager.shared.allItineraries.firstIndex(where: { $0.tag == tag }) {
            DataManager.shared.allItineraries[index].activitiesforvoting = updatedActivities
//            reloadActivitiesForSelectedDay(selectedIndex: index)
            viewDidLoad()
        }
    }
}

class viewitineraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VotingViewController.VotingViewControllerDelegate {
    
    var resultsView: UIView!
    var flightInfo: String = ""
    var stayInfo: String = ""
    var eventTitle: String = ""
    var numdays = 0
    var notesforactivity = ""
    var activitiesForDisplay: [Activity] = []
    var currtag = 0
    var yesVotes = 0
    var noVotes = 0
    var numpeople = 0
    var popupTitle: String?
    var noActivitiesLabel: UILabel!
    var underlineView: UIView!
    let textCellIdentifier = "TextCell"
    @IBOutlet weak var staylabel: UILabel!
    @IBOutlet weak var flightlabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

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
    
    func populateinfo() {
        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            print(currtag)
            titlelabel.text = itinerary.name
            staylabel.text = itinerary.stays
            flightlabel.text = itinerary.flights
            numdays = itinerary.numdays
            numpeople = itinerary.totalpeople
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
        DispatchQueue.main.async {
            customTabs.selectedIndex = 0
            self.reloadActivitiesForSelectedDay(selectedIndex: 0)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesForDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! TimelineActivityCell
        let activity = activitiesForDisplay[indexPath.row]

        
        yesVotes = activity.yesVotes
        noVotes = activity.noVotes
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == activitiesForDisplay.count - 1
        let state: TimelineActivityCell.TimelineState = isFirst ? .highlighted : .normal
        cell.configureTimelinePosition(isFirst: isFirst, isLast: isLast, state: state)
        cell.selectionStyle = .none

        let time = UILabel()
        time.text = formattedTime(from: activity.time)
        time.font = UIFont.boldSystemFont(ofSize: 10)
        time.textColor = UIColor.systemGray2
        time.translatesAutoresizingMaskIntoConstraints = false
        time.backgroundColor = UIColor.white
        cell.contentView.addSubview(time)
        
        
        let titleLabel = UILabel()
        titleLabel.text = activity.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.white
        cell.contentView.addSubview(titleLabel)
        
        let imageView = UIImageView()
        imageView.image = activity.picture
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(imageView)

        let notesLabel = UILabel()
        notesLabel.text = activity.notes
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.font = UIFont.systemFont(ofSize: 12)
        notesLabel.textColor = UIColor.gray
        notesLabel.backgroundColor = UIColor.white
        notesLabel.isUserInteractionEnabled = true
        notesforactivity = activity.notes
        
        let tapGesture = NoteTapGestureRecognizer(target: self, action: #selector(showFullNote(_:)))
        tapGesture.noteText = activity.notes
        notesLabel.addGestureRecognizer(tapGesture)
        cell.contentView.addSubview(notesLabel)
        
        var votebutton: UIButton
        if let existingButton = cell.contentView.viewWithTag(100) as? UIButton {
            votebutton = existingButton
        } else {
            votebutton = UIButton(type: .system)
            votebutton.setTitle("Vote", for: .normal)
            votebutton.setTitleColor(.white, for: .normal)
            votebutton.backgroundColor = UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.00)
            votebutton.layer.cornerRadius = 8
            votebutton.tag = 100
            votebutton.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(votebutton)
        }
        
        votebutton.addTarget(self, action: #selector(voteButtonPressed(_:)), for: .touchUpInside)
        votebutton.isHidden = activity.didvote
        
        NSLayoutConstraint.activate([
            time.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 50),
            time.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 50),
            titleLabel.widthAnchor.constraint(equalToConstant: 500),
            titleLabel.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 10),
            
            notesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            notesLabel.widthAnchor.constraint(equalToConstant: 200),
            notesLabel.heightAnchor.constraint(equalToConstant: 20),
            notesLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 50),
            
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),
            
            votebutton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 50),
            votebutton.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 12),
            votebutton.widthAnchor.constraint(equalToConstant: 80),
            votebutton.heightAnchor.constraint(equalToConstant: 30),
            votebutton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),
            ])
        
        
        let resultsView: UIView
            if let existing = cell.contentView.viewWithTag(999) {
                resultsView = existing
                resultsView.isHidden = !activity.didvote
            } else {
                resultsView = UIView()
                resultsView.tag = 999
                resultsView.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(resultsView)

                let checkIcon = UIImageView(image: UIImage(systemName: "checkmark.circle"))
                checkIcon.tintColor = .gray
                checkIcon.translatesAutoresizingMaskIntoConstraints = false
                resultsView.addSubview(checkIcon)

                let viewLabel = UILabel()
                viewLabel.text = "View Results"
                viewLabel.font = UIFont.systemFont(ofSize: 14)
                viewLabel.textColor = .gray
                viewLabel.translatesAutoresizingMaskIntoConstraints = false
                resultsView.addSubview(viewLabel)

                let avatarStack = UIStackView()
                avatarStack.axis = .horizontal
                avatarStack.spacing = -10
                avatarStack.translatesAutoresizingMaskIntoConstraints = false
                resultsView.addSubview(avatarStack)

                let imageNames = ["person1", "person2", "person3"]
                for name in imageNames {
                    let avatar = UIImageView(image: UIImage(named: name))
                    avatar.layer.cornerRadius = 12
                    avatar.clipsToBounds = true
                    avatar.translatesAutoresizingMaskIntoConstraints = false
                    avatar.widthAnchor.constraint(equalToConstant: 24).isActive = true
                    avatar.heightAnchor.constraint(equalToConstant: 24).isActive = true
                    avatarStack.addArrangedSubview(avatar)
                }

                NSLayoutConstraint.activate([
                    resultsView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 12),
                    resultsView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 50),
                    resultsView.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor, constant: -20),
                    resultsView.heightAnchor.constraint(equalToConstant: 40),
                    resultsView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),

                    checkIcon.leadingAnchor.constraint(equalTo: resultsView.leadingAnchor),
                    checkIcon.centerYAnchor.constraint(equalTo: viewLabel.centerYAnchor),
                    checkIcon.widthAnchor.constraint(equalToConstant: 20),
                    checkIcon.heightAnchor.constraint(equalToConstant: 20),

                    viewLabel.leadingAnchor.constraint(equalTo: checkIcon.trailingAnchor, constant: 8),
                    viewLabel.topAnchor.constraint(equalTo: resultsView.topAnchor),

                    avatarStack.leadingAnchor.constraint(equalTo: resultsView.leadingAnchor),
                    avatarStack.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 4),
                    avatarStack.bottomAnchor.constraint(equalTo: resultsView.bottomAnchor)
                ])

                resultsView.gestureRecognizers?.forEach { resultsView.removeGestureRecognizer($0) }
                resultsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showVotingResults)))
                resultsView.isUserInteractionEnabled = true
                resultsView.isHidden = !activity.didvote
                cell.contentView.bringSubviewToFront(resultsView)
            }

            return cell
        }
    
    @objc func showFullNote(_ sender: NoteTapGestureRecognizer) {
        let popup = TextPopupViewController()
        popup.popupTitle = "Notes"
        popup.popupText = notesforactivity
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true)
    }
    
    @objc func showVotingResults() {
        let popup = UIViewController()
        let popupTitle = eventTitle + " Results"
        popup.modalPresentationStyle = .popover
        popup.preferredContentSize = CGSize(width: 300, height: 250)

        // Add dismiss gesture to the popup
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        popup.view.addGestureRecognizer(dismissTap)

        // Container view
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        popup.view.addSubview(container)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: popup.view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: popup.view.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 260),
            container.heightAnchor.constraint(equalToConstant: 200)
        ])

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = popupTitle
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])

        let grayyes = UIView()
        grayyes.backgroundColor = .systemGray6
        grayyes.translatesAutoresizingMaskIntoConstraints = false
        grayyes.layer.cornerRadius = 4
        container.addSubview(grayyes)
        
        let grayno = UIView()
        grayno.backgroundColor = .systemGray6
        grayno.translatesAutoresizingMaskIntoConstraints = false
        grayno.layer.cornerRadius = 4

        container.addSubview(grayno)
        
        let grayna = UIView()
        grayna.backgroundColor = .systemGray6
        grayna.translatesAutoresizingMaskIntoConstraints = false
        grayna.layer.cornerRadius = 4

        container.addSubview(grayna)
        
        
        let yesRectangle = UIView()
        yesRectangle.backgroundColor = .systemGreen
        yesRectangle.translatesAutoresizingMaskIntoConstraints = false
        yesRectangle.layer.cornerRadius = 4

        container.addSubview(yesRectangle)


        
        let noRectangle = UIView()
        noRectangle.backgroundColor = .systemRed
        noRectangle.translatesAutoresizingMaskIntoConstraints = false
        noRectangle.layer.cornerRadius = 4
        noRectangle.tag = 103
        container.addSubview(noRectangle)
        
        let yesLabel = UILabel()
        yesLabel.text = "Yes"
        yesLabel.font = UIFont.boldSystemFont(ofSize: 10)
        yesLabel.translatesAutoresizingMaskIntoConstraints = false
        yesLabel.tag = 104
        container.addSubview(yesLabel)
        
        let noLabel = UILabel()
        noLabel.text = "No"
        noLabel.font = UIFont.boldSystemFont(ofSize: 10)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noLabel.tag = 105
        container.addSubview(noLabel)
        
        let yesnumlabel = UILabel()
        yesnumlabel.text = String(yesVotes)
        yesnumlabel.font = UIFont.boldSystemFont(ofSize: 10)
        yesnumlabel.translatesAutoresizingMaskIntoConstraints = false
        yesnumlabel.tag = 106
        container.addSubview(yesnumlabel)
        
        let nonumlabel = UILabel()
        nonumlabel.text = String(noVotes)
        nonumlabel.font = UIFont.boldSystemFont(ofSize: 10)
        nonumlabel.translatesAutoresizingMaskIntoConstraints = false
        nonumlabel.tag = 107
        container.addSubview(nonumlabel)
        
        let naLabel = UILabel()
        naLabel.text = "N/A"
        naLabel.font = UIFont.boldSystemFont(ofSize: 10)
        naLabel.translatesAutoresizingMaskIntoConstraints = false
        naLabel.tag = 108
        container.addSubview(naLabel)
        
        let nanumlabel = UILabel()
        nanumlabel.text = String(numpeople - (noVotes + yesVotes))
        nanumlabel.font = UIFont.boldSystemFont(ofSize: 10)
        nanumlabel.translatesAutoresizingMaskIntoConstraints = false
        nanumlabel.tag = 109
        container.addSubview(nanumlabel)
        
        let naRectangle = UIView()
        naRectangle.backgroundColor = .systemGray2
        naRectangle.translatesAutoresizingMaskIntoConstraints = false
        naRectangle.layer.cornerRadius = 4
        naRectangle.tag = 110
        container.addSubview(naRectangle)
        
        let yesPercentLabel = UILabel()
        yesPercentLabel.text = "\(Int(CGFloat(yesVotes) / CGFloat(numpeople) * 100))%"
        yesPercentLabel.font = UIFont.systemFont(ofSize: 10)
        yesPercentLabel.textColor = .gray
        yesPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        yesPercentLabel.tag = 114
        container.addSubview(yesPercentLabel)

        let noPercentLabel = UILabel()
        noPercentLabel.text = "\(Int(CGFloat(noVotes) / CGFloat(numpeople) * 100))%"
        noPercentLabel.font = UIFont.systemFont(ofSize: 10)
        noPercentLabel.textColor = .gray
        noPercentLabel.tag = 115
        noPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(noPercentLabel)

        let naVotes = numpeople - (yesVotes + noVotes)
        
        let naPercentLabel = UILabel()
        naPercentLabel.text = "\(Int(CGFloat(naVotes) / CGFloat(numpeople) * 100))%"
        naPercentLabel.font = UIFont.systemFont(ofSize: 10)
        naPercentLabel.textColor = .gray
        naPercentLabel.tag = 116
        naPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(naPercentLabel)
        
        NSLayoutConstraint.activate([
            yesRectangle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            yesRectangle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yesRectangle.heightAnchor.constraint(equalToConstant: 10),
            yesRectangle.widthAnchor.constraint(equalToConstant: CGFloat(yesVotes) / CGFloat(numpeople) * 200),
            
            grayyes.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            grayyes.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            grayyes.heightAnchor.constraint(equalToConstant: 10),
            grayyes.widthAnchor.constraint(equalToConstant: 200),
            
            grayno.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            grayno.topAnchor.constraint(equalTo: yesRectangle.bottomAnchor, constant: 30),
            grayno.heightAnchor.constraint(equalToConstant: 10),
            grayno.widthAnchor.constraint(equalToConstant: 200),
            
            grayna.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            grayna.topAnchor.constraint(equalTo: noRectangle.bottomAnchor, constant: 30),
            grayna.heightAnchor.constraint(equalToConstant: 10),
            grayna.widthAnchor.constraint(equalToConstant: 200),
            
            noRectangle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            noRectangle.topAnchor.constraint(equalTo: yesRectangle.bottomAnchor, constant: 30),
            noRectangle.heightAnchor.constraint(equalToConstant: 10),
            noRectangle.widthAnchor.constraint(equalToConstant: CGFloat(noVotes) / CGFloat(numpeople) * 200),
            
            naRectangle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            naRectangle.topAnchor.constraint(equalTo: noRectangle.bottomAnchor, constant: 30),
            naRectangle.heightAnchor.constraint(equalToConstant: 10),
            naRectangle.widthAnchor.constraint(equalToConstant: CGFloat(numpeople - (noVotes + yesVotes)) / CGFloat(numpeople) * 200),
            
    
            yesLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
            yesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            
            noLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
            noLabel.topAnchor.constraint(equalTo: noRectangle.topAnchor, constant: -12),
            
            naLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
            naLabel.topAnchor.constraint(equalTo: naRectangle.topAnchor, constant: -12),
            
            yesPercentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 200),
            yesPercentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            
            noPercentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 200),
            noPercentLabel.topAnchor.constraint(equalTo: noRectangle.topAnchor, constant: -12),
            
            naPercentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 200),
            naPercentLabel.topAnchor.constraint(equalTo: naRectangle.topAnchor, constant: -12)
            
            
        ])
        
        if let popover = popup.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 1, height: 1)
            popover.permittedArrowDirections = []
        }

        present(popup, animated: true)
    }
    
    @objc func dismissPopup() {
        dismiss(animated: true)
    }
    

    func formattedTime(from interval: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current

        let midnight = Calendar.current.startOfDay(for: Date())
        let time = midnight.addingTimeInterval(interval)
        return formatter.string(from: time)
    }

    
    @objc func voteButtonPressed(_ sender: UIButton) {
        if let votingVC = storyboard?.instantiateViewController(withIdentifier: "VotingViewControllerID") as? VotingViewController {
            if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
                votingVC.currtag = itinerary.tag
                votingVC.delegate = self
            }
            self.present(votingVC, animated: true)
        }
    }
    

    func reloadActivitiesForSelectedDay(selectedIndex: Int) {
        let selectedDay = selectedIndex + 1
        activitiesForDisplay.removeAll()

        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            if let activitiesForSelectedDay = itinerary.activitiesforday[selectedDay], !activitiesForSelectedDay.isEmpty {
                if let activitiesForSelectedDay = itinerary.activitiesforday[selectedDay] {
                    activitiesForDisplay = activitiesForSelectedDay.sorted { $0.time < $1.time }

                }
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
            if let destinationVC = segue.destination as? EditEventVC {
                destinationVC.currtag = self.currtag
            }
        }
        if segue.identifier == "ShowVotingViewController",
           let destinationVC = segue.destination as? VotingViewController {
            if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
               destinationVC.currtag = currtag
                }
            }
        }
    
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
        noActivitiesLabel.isHidden = true
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
        underlineView.backgroundColor = UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.00)
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
                    .foregroundColor: (i == selectedIndex ? UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.00) : UIColor.gray)
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
                    .foregroundColor: (i == selectedIndex ? UIColor(red: 0.99, green: 0.29, blue: 0.03, alpha: 1.00) : UIColor.gray)
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






class TextPopupViewController: UIViewController {

    var popupTitle: String?
    var popupText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(dismissTap)
        
        let titleLabel = UILabel()
        titleLabel.text = popupTitle
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let textLabel = UILabel()
        textLabel.text = popupText
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(titleLabel)
        container.addSubview(textLabel)

        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 300),
            container.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),

            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func dismissPopup() {
        dismiss(animated: true)
    }
}

class VotingPopupViewController: UIViewController {

    var popupTitle: String?
    var popupText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    

}


class NoteTapGestureRecognizer: UITapGestureRecognizer {
    var noteText: String?
}
