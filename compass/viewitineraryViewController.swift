//
//  viewitineraryViewController.swift
//  compass
//
//  Created by Denise Ramos on 3/25/25.
//

import UIKit

class viewitineraryViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeader()
        setupTripDetails()
        setupDayTabs()
        setupItineraryList()
    }

    func setupHeader() {
        let headerLabel = UILabel()
        headerLabel.text = "My Trip to Paris \u{1F1EB}\u{1F1F7}"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 28)
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    func setupTripDetails() {
        // Add flight and stay details with rounded cards
    }

    func setupDayTabs() {
        // Create horizontal stack view for days
    }

    func setupItineraryList() {
        let itineraryStack = UIStackView()
        itineraryStack.axis = .vertical
        itineraryStack.spacing = 10
        itineraryStack.translatesAutoresizingMaskIntoConstraints = false

        let louvre = createItineraryItem(title: "Louvre", votes: "6/10", imageName: "louvre")
        let eiffel = createItineraryItem(title: "Eiffel Tower", votes: "VOTE", imageName: "eiffel")

        itineraryStack.addArrangedSubview(louvre)
        itineraryStack.addArrangedSubview(eiffel)

        contentView.addSubview(itineraryStack)

        NSLayoutConstraint.activate([
            itineraryStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 150),
            itineraryStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itineraryStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    func createItineraryItem(title: String, votes: String, imageName: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let voteButton = UIButton(type: .system)
        voteButton.setTitle(votes, for: .normal)
        voteButton.backgroundColor = .systemOrange
        voteButton.setTitleColor(.white, for: .normal)
        voteButton.layer.cornerRadius = 8
        voteButton.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(voteButton)

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])

        return view
    }
}
