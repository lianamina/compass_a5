import UIKit

class EventCell: UITableViewCell {
    
    // UI Elements
    let titleLabel = UILabel()
    let imageViewEvent = UIImageView()
    let yesButton = UIButton(type: .system)
    let noButton = UIButton(type: .system)
    let countdownLabel = UILabel()

    // Timer
    var timer: Timer?
    var endTime: Date?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none

        // Title Label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Image View
        imageViewEvent.contentMode = .scaleAspectFill
        imageViewEvent.clipsToBounds = true
        imageViewEvent.layer.cornerRadius = 8
        imageViewEvent.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageViewEvent)

        // Yes Button
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.backgroundColor = .systemGreen
        yesButton.layer.cornerRadius = 8
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(yesButton)

        // No Button
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(.white, for: .normal)
        noButton.backgroundColor = .systemRed
        noButton.layer.cornerRadius = 8
        noButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(noButton)

        // Countdown Label
        countdownLabel.font = UIFont.systemFont(ofSize: 18)
        countdownLabel.textColor = .systemBlue
        countdownLabel.textAlignment = .center
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countdownLabel)

        // Constraints
        NSLayoutConstraint.activate([
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            // Image
            imageViewEvent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageViewEvent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageViewEvent.widthAnchor.constraint(equalToConstant: 80),
            imageViewEvent.heightAnchor.constraint(equalToConstant: 80),
            
            // Yes Button
            yesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            yesButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yesButton.widthAnchor.constraint(equalToConstant: 80),
            yesButton.heightAnchor.constraint(equalToConstant: 40),

            // No Button
            noButton.leadingAnchor.constraint(equalTo: yesButton.trailingAnchor, constant: 20),
            noButton.topAnchor.constraint(equalTo: yesButton.topAnchor),
            noButton.widthAnchor.constraint(equalToConstant: 80),
            noButton.heightAnchor.constraint(equalToConstant: 40),

            // Countdown Label
            countdownLabel.topAnchor.constraint(equalTo: yesButton.bottomAnchor, constant: 20),
            countdownLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            countdownLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            countdownLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)  // Ensure enough bottom padding
        ])
    }

    // Configure the cell with event data
    func configure(with title: String, image: UIImage?, endTime: Date) {
        titleLabel.text = title
        imageViewEvent.image = image
        self.endTime = endTime
        startCountdown()
    }

    private func startCountdown() {
        timer?.invalidate()

        guard let endTime = endTime else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let remainingTime = endTime.timeIntervalSince(Date())

            if remainingTime <= 0 {
                self.countdownLabel.text = "Event ended"
                self.timer?.invalidate()
            } else {
                let minutes = Int(remainingTime) / 60
                let seconds = Int(remainingTime) % 60
                self.countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        countdownLabel.text = ""
    }
}

