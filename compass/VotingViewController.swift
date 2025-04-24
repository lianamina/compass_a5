import UIKit





class VotingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let totalnumberofpeople = 10
    var numrow = 0
    let textCellIdentifier = "TextCell"
    var timers: [IndexPath: Timer] = [:]
    var eventEndTimes: [IndexPath: Date] = [:]
    var endTime: Date?
    var currtag = 1
    var numpeople = 0
    var votingactivities: [Activity] = []
    weak var delegate: VotingViewControllerDelegate?

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
        if let itinerary = DataManager.shared.allItineraries.first(where: { $0.tag == currtag }) {
            votingactivities = itinerary.activitiesforvoting.filter { !$0.didvote }
            numpeople = itinerary.totalpeople
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

        timers[indexPath]?.invalidate()

        let countdownLabel = UILabel()
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.font = UIFont.systemFont(ofSize: 16)
        countdownLabel.textColor = .systemBlue
        countdownLabel.text = "00:00:00"
        cell.contentView.addSubview(countdownLabel)
        
        let key = "votingEndTime-\(currtag)-\(activity.title)"
        let defaults = UserDefaults.standard

        // Retrieve or set persistent endTime
        var endTime: Date
        if let saved = defaults.object(forKey: key) as? Date {
            endTime = Date().addingTimeInterval(86400)
        } else {
            endTime = Date().addingTimeInterval(86400)
            defaults.set(endTime, forKey: key)
        }

        eventEndTimes[indexPath] = endTime
        
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

        let titleLabel = UILabel()
        titleLabel.text = activity.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(titleLabel)

        let imageView = UIImageView()
        imageView.image = activity.picture
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(imageView)

        let yesButton = UIButton(type: .system)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.backgroundColor = .systemGreen
        yesButton.layer.cornerRadius = 8
        yesButton.tag = 100  // Assign a unique tag
        yesButton.isHidden = false
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(yesButton)

        let noButton = UIButton(type: .system)
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(.white, for: .normal)
        noButton.backgroundColor = .systemRed
        noButton.layer.cornerRadius = 8
        noButton.tag = 101  // Assign a unique tag
        noButton.isHidden = false
        noButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(noButton)

        let grayyes = UIView()
        grayyes.backgroundColor = .systemGray6
        grayyes.translatesAutoresizingMaskIntoConstraints = false
        grayyes.layer.cornerRadius = 4
        grayyes.tag = 111
        grayyes.isHidden = true
        cell.contentView.addSubview(grayyes)
        
        let grayno = UIView()
        grayno.backgroundColor = .systemGray6
        grayno.translatesAutoresizingMaskIntoConstraints = false
        grayno.layer.cornerRadius = 4
        grayno.tag = 112
        grayno.isHidden = true
        cell.contentView.addSubview(grayno)
        
        let grayna = UIView()
        grayna.backgroundColor = .systemGray6
        grayna.translatesAutoresizingMaskIntoConstraints = false
        grayna.layer.cornerRadius = 4
        grayna.tag = 113
        grayna.isHidden = true
        cell.contentView.addSubview(grayna)
        
        
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
        
        let yesLabel = UILabel()
        yesLabel.text = "Yes"
        yesLabel.font = UIFont.boldSystemFont(ofSize: 10)
        yesLabel.translatesAutoresizingMaskIntoConstraints = false
        yesLabel.isHidden = true
        yesLabel.tag = 104
        cell.contentView.addSubview(yesLabel)
        
        let noLabel = UILabel()
        noLabel.text = "No"
        noLabel.font = UIFont.boldSystemFont(ofSize: 10)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noLabel.isHidden = true
        noLabel.tag = 105
        cell.contentView.addSubview(noLabel)
        
        let yesnumlabel = UILabel()
        yesnumlabel.text = String(activity.yesVotes) ?? ""
        yesnumlabel.font = UIFont.boldSystemFont(ofSize: 10)
        yesnumlabel.translatesAutoresizingMaskIntoConstraints = false
        yesnumlabel.isHidden = true
        yesnumlabel.tag = 106
        cell.contentView.addSubview(yesnumlabel)
        
        let nonumlabel = UILabel()
        nonumlabel.text = String(activity.noVotes) ?? ""
        nonumlabel.font = UIFont.boldSystemFont(ofSize: 10)
        nonumlabel.translatesAutoresizingMaskIntoConstraints = false
        nonumlabel.isHidden = true
        nonumlabel.tag = 107
        cell.contentView.addSubview(nonumlabel)
        
        let naLabel = UILabel()
        naLabel.text = "N/A"
        naLabel.font = UIFont.boldSystemFont(ofSize: 10)
        naLabel.translatesAutoresizingMaskIntoConstraints = false
        naLabel.tag = 108
        naLabel.isHidden = true
        cell.contentView.addSubview(naLabel)
        
        let nanumlabel = UILabel()
        nanumlabel.text = String(numpeople - (activity.noVotes + activity.yesVotes)) ?? ""
        nanumlabel.font = UIFont.boldSystemFont(ofSize: 10)
        nanumlabel.translatesAutoresizingMaskIntoConstraints = false
        nanumlabel.isHidden = true
        nanumlabel.tag = 109
        cell.contentView.addSubview(nanumlabel)
        
        let naRectangle = UIView()
        naRectangle.backgroundColor = .systemGray2
        naRectangle.translatesAutoresizingMaskIntoConstraints = false
        naRectangle.layer.cornerRadius = 4
        naRectangle.tag = 110
        naRectangle.isHidden = true
        cell.contentView.addSubview(naRectangle)
        
        let yesPercentLabel = UILabel()
        yesPercentLabel.text = "\(Int(CGFloat(activity.yesVotes) / CGFloat(numpeople) * 100))%"
        yesPercentLabel.font = UIFont.systemFont(ofSize: 10)
        yesPercentLabel.textColor = .gray
        yesPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        yesPercentLabel.tag = 114
        yesPercentLabel.isHidden = true
        cell.contentView.addSubview(yesPercentLabel)

        let noPercentLabel = UILabel()
        noPercentLabel.text = "\(Int(CGFloat(activity.noVotes) / CGFloat(numpeople) * 100))%"
        noPercentLabel.font = UIFont.systemFont(ofSize: 10)
        noPercentLabel.textColor = .gray
        noPercentLabel.tag = 115
        noPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        noPercentLabel.isHidden = true
        cell.contentView.addSubview(noPercentLabel)

        let naVotes = numpeople - (activity.yesVotes + activity.noVotes)
        
        let naPercentLabel = UILabel()
        naPercentLabel.text = "\(Int(CGFloat(naVotes) / CGFloat(numpeople) * 100))%"
        naPercentLabel.font = UIFont.systemFont(ofSize: 10)
        naPercentLabel.textColor = .gray
        naPercentLabel.tag = 116
        naPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        naPercentLabel.isHidden = true
        cell.contentView.addSubview(naPercentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            yesButton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            yesButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yesButton.widthAnchor.constraint(equalToConstant: 80),
            yesButton.heightAnchor.constraint(equalToConstant: 30),
            
            noButton.leadingAnchor.constraint(equalTo: yesButton.trailingAnchor, constant: 20),
            noButton.topAnchor.constraint(equalTo: yesButton.topAnchor),
            noButton.widthAnchor.constraint(equalToConstant: 80),
            noButton.heightAnchor.constraint(equalToConstant: 30),
            
            yesRectangle.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            yesRectangle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yesRectangle.heightAnchor.constraint(equalToConstant: 10),
            yesRectangle.widthAnchor.constraint(equalToConstant: CGFloat(activity.yesVotes) / CGFloat(numpeople) * 200),
            
            grayyes.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            grayyes.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            grayyes.heightAnchor.constraint(equalToConstant: 10),
            grayyes.widthAnchor.constraint(equalToConstant: 200),
            
            grayno.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            grayno.topAnchor.constraint(equalTo: yesButton.bottomAnchor, constant: 10),
            grayno.heightAnchor.constraint(equalToConstant: 10),
            grayno.widthAnchor.constraint(equalToConstant: 200),
            
            grayna.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            grayna.topAnchor.constraint(equalTo: noRectangle.bottomAnchor, constant: 30),
            grayna.heightAnchor.constraint(equalToConstant: 10),
            grayna.widthAnchor.constraint(equalToConstant: 200),
            
            noRectangle.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            noRectangle.topAnchor.constraint(equalTo: yesButton.bottomAnchor, constant: 10),
            noRectangle.heightAnchor.constraint(equalToConstant: 10),
            noRectangle.widthAnchor.constraint(equalToConstant: CGFloat(activity.noVotes) / CGFloat(numpeople) * 200),
            
            naRectangle.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            naRectangle.topAnchor.constraint(equalTo: noRectangle.bottomAnchor, constant: 30),
            naRectangle.heightAnchor.constraint(equalToConstant: 10),
            naRectangle.widthAnchor.constraint(equalToConstant: CGFloat(numpeople - (activity.noVotes + activity.yesVotes)) / CGFloat(numpeople) * 200),
            
    
            yesLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 25),
            yesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            
            noLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 25),
            noLabel.topAnchor.constraint(equalTo: noRectangle.topAnchor, constant: -12),
            
            naLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 25),
            naLabel.topAnchor.constraint(equalTo: naRectangle.topAnchor, constant: -12),
            
            countdownLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            countdownLabel.topAnchor.constraint(equalTo: naRectangle.bottomAnchor, constant: 20),
            countdownLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),
            
            yesPercentLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 200),
            yesPercentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            
            noPercentLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 200),
            noPercentLabel.topAnchor.constraint(equalTo: noRectangle.topAnchor, constant: -12),
            
            naPercentLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 200),
            naPercentLabel.topAnchor.constraint(equalTo: naRectangle.topAnchor, constant: -12)
            
            

        ])

        yesButton.addTarget(self, action: #selector(yesButtonPressed(_:)), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(noButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func yesButtonPressed(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)  {
            let activity = votingactivities[indexPath.row]
            activity.yesVotes += 1
            activity.didvote = true

            
            cell.contentView.viewWithTag(100)!.isHidden = true  // yes button
            cell.contentView.viewWithTag(101)!.isHidden = true  // no button
            cell.contentView.viewWithTag(102)!.isHidden = false // yes rectangle
            cell.contentView.viewWithTag(103)!.isHidden = false // no rectangle
            cell.contentView.viewWithTag(110)!.isHidden = false // na ractangle
            cell.contentView.viewWithTag(104)!.isHidden = false // yes label
            cell.contentView.viewWithTag(105)!.isHidden = false // no label
            cell.contentView.viewWithTag(108)!.isHidden = false // na label
            cell.contentView.viewWithTag(114)!.isHidden = false  // yes percent
            cell.contentView.viewWithTag(115)!.isHidden = false  // no perccent
            cell.contentView.viewWithTag(116)!.isHidden = false  // na percent
            cell.contentView.viewWithTag(111)!.isHidden = false  // gray yes
            cell.contentView.viewWithTag(112)!.isHidden = false  // gray no
            cell.contentView.viewWithTag(113)!.isHidden = false  // gray na
            
            NSLayoutConstraint.activate([
            cell.contentView.viewWithTag(102)!.widthAnchor.constraint(equalToConstant: CGFloat(3) / CGFloat(6) * 200) ,  // yes rectangle
            cell.contentView.viewWithTag(103)!.widthAnchor.constraint(equalToConstant: CGFloat(activity.noVotes) / CGFloat(numpeople) * 200) ,   // no rectangle
            cell.contentView.viewWithTag(110)!.widthAnchor.constraint(equalToConstant: CGFloat(numpeople - (activity.noVotes + activity.yesVotes)) / CGFloat(numpeople) * 200)  // na rectangle
            ])
        }
    }
    
    @objc func noButtonPressed(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)  {
            let activity = votingactivities[indexPath.row]
            activity.noVotes += 1
            activity.didvote = true
            
            cell.contentView.viewWithTag(100)!.isHidden = true  // yes button
            cell.contentView.viewWithTag(101)!.isHidden = true  // no button
            cell.contentView.viewWithTag(102)!.isHidden = false // yes rectangle
            cell.contentView.viewWithTag(103)!.isHidden = false // no rectangle
            cell.contentView.viewWithTag(110)!.isHidden = false // na ractangle
            cell.contentView.viewWithTag(104)!.isHidden = false // yes label
            cell.contentView.viewWithTag(105)!.isHidden = false // no label
            cell.contentView.viewWithTag(108)!.isHidden = false // na label
            cell.contentView.viewWithTag(114)!.isHidden = false  // yes percent
            cell.contentView.viewWithTag(115)!.isHidden = false  // no perccent
            cell.contentView.viewWithTag(116)!.isHidden = false  // na percent
            cell.contentView.viewWithTag(111)!.isHidden = false  // gray yes
            cell.contentView.viewWithTag(112)!.isHidden = false  // gray no
            cell.contentView.viewWithTag(113)!.isHidden = false  // gray na
            
            NSLayoutConstraint.activate([
            cell.contentView.viewWithTag(102)!.widthAnchor.constraint(equalToConstant: CGFloat(activity.yesVotes) / CGFloat(numpeople) * 200) ,  // yes rectangle
            cell.contentView.viewWithTag(103)!.widthAnchor.constraint(equalToConstant: CGFloat(4) / CGFloat(6) * 200) ,   // no rectangle
            cell.contentView.viewWithTag(110)!.widthAnchor.constraint(equalToConstant: CGFloat(numpeople - (activity.noVotes + activity.yesVotes)) / CGFloat(numpeople) * 200)  // na rectangle
            ])
            
        }
        
    }
    
    protocol VotingViewControllerDelegate: AnyObject {
        func didUpdateVotes(for tag: Int, updatedActivities: [Activity])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didUpdateVotes(for: currtag, updatedActivities: votingactivities)
    }
}
