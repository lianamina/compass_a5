import UIKit





class VotingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let totalnumberofpeople = 10
    var numrow = 0
    let textCellIdentifier = "TextCell"
    var timers: [IndexPath: Timer] = [:]
    var eventEndTimes: [IndexPath: Date] = [:]  // Store event end times
    var currtag = 1
    var votingactivities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            votingactivities = itinerary.activitiesforvoting
        }
        tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return votingactivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let activity = votingactivities[indexPath.row]

        // Make sure previous timer is invalidated before creating a new one
        timers[indexPath]?.invalidate()


        // Countdown Label
        let countdownLabel = UILabel()
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.font = UIFont.systemFont(ofSize: 16)
        countdownLabel.textColor = .systemBlue
        countdownLabel.text = "00:00:00" // Placeholder text
        cell.contentView.addSubview(countdownLabel)



        // Store it in eventEndTimes
        let endTime = eventEndTimes[indexPath] ?? Date().addingTimeInterval(86400)
        
        eventEndTimes[indexPath] = endTime


        // Create a timer that updates every second
        timers[indexPath] = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            let now = Date()
            let remainingTime = endTime.timeIntervalSince(now)

            if remainingTime <= 0 {
                countdownLabel.text = "Voting Window ended"
                self?.timers[indexPath]?.invalidate()
            } else {
                let hours = Int(remainingTime) / 3600 // Calculate hours
                let minutes = (Int(remainingTime) % 3600) / 60 // Calculate minutes (remaining after hours)
                let seconds = Int(remainingTime) % 60 // Calculate seconds (remaining after minutes)

                countdownLabel.text = String(format: "Time remaining: %02d:%02d:%02d", hours, minutes, seconds)
            }
        }

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = activity.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(titleLabel)

        // Image View
        let imageView = UIImageView()
        imageView.image = activity.picture  // Replace with your image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(imageView)

        // Yes Button
        let yesButton = UIButton(type: .system)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.backgroundColor = .systemGreen
        yesButton.layer.cornerRadius = 8
        yesButton.tag = 100  // Assign a unique tag
        yesButton.isHidden = false
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(yesButton)

        // No Button
        let noButton = UIButton(type: .system)
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(.white, for: .normal)
        noButton.backgroundColor = .systemRed
        noButton.layer.cornerRadius = 8
        noButton.tag = 101  // Assign a unique tag
        noButton.isHidden = false
        noButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(noButton)

        // Progress Rectangles (for Yes and No votes)
        let yesRectangle = UIView()
        yesRectangle.backgroundColor = .systemGreen
        yesRectangle.translatesAutoresizingMaskIntoConstraints = false
        yesRectangle.layer.cornerRadius = 4
        yesRectangle.tag = 102
        yesRectangle.isHidden = true
        cell.contentView.addSubview(yesRectangle)

        let noRectangle = UIView()
        noRectangle.backgroundColor = .systemRed
        noRectangle.translatesAutoresizingMaskIntoConstraints = false
        noRectangle.layer.cornerRadius = 4
        noRectangle.tag = 103
        noRectangle.isHidden = true
        cell.contentView.addSubview(noRectangle)
        
        // yes label
        let yesLabel = UILabel()
        yesLabel.text = "Yes"
        yesLabel.font = UIFont.boldSystemFont(ofSize: 10)
        yesLabel.translatesAutoresizingMaskIntoConstraints = false
        yesLabel.isHidden = true
        yesLabel.tag = 104
        cell.contentView.addSubview(yesLabel)
        
        // no label
        let noLabel = UILabel()
        noLabel.text = "No"
        noLabel.font = UIFont.boldSystemFont(ofSize: 10)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noLabel.isHidden = true
        noLabel.tag = 105
        cell.contentView.addSubview(noLabel)
        

        // total votes label

        // Apply Constraints
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),

            // Image view constraints (right side)
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            // Yes button constraints
            yesButton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            yesButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yesButton.widthAnchor.constraint(equalToConstant: 80),
            yesButton.heightAnchor.constraint(equalToConstant: 30),

            // No button constraints
            noButton.leadingAnchor.constraint(equalTo: yesButton.trailingAnchor, constant: 20),
            noButton.topAnchor.constraint(equalTo: yesButton.topAnchor),
            noButton.widthAnchor.constraint(equalToConstant: 80),
            noButton.heightAnchor.constraint(equalToConstant: 30),

            // Yes Rectangle constraints
            yesRectangle.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            yesRectangle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yesRectangle.heightAnchor.constraint(equalToConstant: 20),
            yesRectangle.widthAnchor.constraint(equalToConstant: CGFloat(activity.yesVotes) / CGFloat(activity.yesVotes + activity.noVotes) * 200), // Adjust width based on vote count

            // No Rectangle constraints
            noRectangle.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            noRectangle.topAnchor.constraint(equalTo: yesButton.bottomAnchor, constant: 10),
            noRectangle.heightAnchor.constraint(equalToConstant: 20),
            noRectangle.widthAnchor.constraint(equalToConstant: CGFloat(activity.noVotes) / CGFloat(activity.yesVotes + activity.noVotes) * 200), // Adjust width based on vote count
            
            // yeslabl
            yesLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 25),
            yesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            
            // no label
            noLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 25),
            noLabel.topAnchor.constraint(equalTo: yesButton.bottomAnchor, constant: 15),
            
            // Countdown label constraints
            countdownLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            countdownLabel.topAnchor.constraint(equalTo: noRectangle.bottomAnchor, constant: 20),
            countdownLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30)
        ])

        yesButton.addTarget(self, action: #selector(yesButtonPressed(_:)), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(noButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func yesButtonPressed(_ sender: UIButton) {
        // Find the cell using the tag
        if let cell = sender.superview?.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)  {
            let activity = votingactivities[indexPath.row]
            activity.yesVotes += 1
            
            if let yesButton = cell.contentView.viewWithTag(100) {
                yesButton.isHidden = true  // Hide the Yes button
            }
            if let noButton = cell.contentView.viewWithTag(101) {
                noButton.isHidden = true  // Hide the No button
            }
            if let yesRectangle = cell.contentView.viewWithTag(102) {
                NSLayoutConstraint.activate([
                    yesRectangle.widthAnchor.constraint(equalToConstant: CGFloat(activity.yesVotes) / CGFloat(activity.yesVotes + activity.noVotes) * 200) // Adjust width based on vote count
                ])
                yesRectangle.isHidden = false
            }
            if let noRectangle = cell.contentView.viewWithTag(103) {
                NSLayoutConstraint.activate([
                    noRectangle.widthAnchor.constraint(equalToConstant: CGFloat(activity.noVotes) / CGFloat(activity.yesVotes + activity.noVotes) * 200) // Adjust width based on vote count
                ])
                noRectangle.isHidden = false
            }
            if let yesLabel = cell.contentView.viewWithTag(104) {
                yesLabel.isHidden = false
            }
            if let noLabel = cell.contentView.viewWithTag(105) {
                noLabel.isHidden = false
            }
            
        }
        
    }
    
    @objc func noButtonPressed(_ sender: UIButton) {
        // Find the cell using the tag
        if let cell = sender.superview?.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)  {
            let activity = votingactivities[indexPath.row]
            activity.noVotes += 1
            if let yesButton = cell.contentView.viewWithTag(100) {
                yesButton.isHidden = true  // Hide the Yes button
            }
            if let noButton = cell.contentView.viewWithTag(101) {
                noButton.isHidden = true  // Hide the No button
            }
            if let yesRectangle = cell.contentView.viewWithTag(102) {
                NSLayoutConstraint.activate([
                    yesRectangle.widthAnchor.constraint(equalToConstant: CGFloat(activity.yesVotes) / CGFloat(activity.yesVotes + activity.noVotes) * 200) // Adjust width based on vote count
                ])
                yesRectangle.isHidden = false
            }
            if let noRectangle = cell.contentView.viewWithTag(103) {
                NSLayoutConstraint.activate([
                    noRectangle.widthAnchor.constraint(equalToConstant: CGFloat(activity.noVotes) / CGFloat(activity.yesVotes + activity.noVotes) * 200) // Adjust width based on vote count
                ])
                noRectangle.isHidden = false
            }
            if let yesLabel = cell.contentView.viewWithTag(104) {
                yesLabel.isHidden = false
            }
            if let noLabel = cell.contentView.viewWithTag(105) {
                noLabel.isHidden = false
            }
        }
    }
}
