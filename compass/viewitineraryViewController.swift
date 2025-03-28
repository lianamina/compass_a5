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
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tripDetailsStack: UIStackView!
    @IBOutlet weak var dayTabs: UISegmentedControl!
    @IBOutlet weak var itineraryStack: UIStackView!
    
    @IBOutlet weak var bottomTabBar: UITabBar!
    

    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupScrollViewConstraints()
            setupHeader()
            setupTripDetails()
            setupDayTabs()
            setupItineraryList()
            setupBottomTabBar()
        }

        func setupScrollViewConstraints() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }

        func setupHeader() {
            headerLabel.text = "My Trip to Paris 🇫🇷"
            headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
            headerLabel.textAlignment = .center
        }

    func setupTripDetails() {
        tripDetailsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let flightCard = createCard(
            title: "Flights",
            details: """
                Confirmation #: KPS43
                Airline: United Airlines
                Date: Thursday, July 14th
                Departure: SFO 11:32am
                Arrival: CDG 5:32pm
            """,
            imageName: "flight"
        )
        
        let stayCard = createCard(title: "Stays", details: "Condo in Les Halles", imageName: "stay")

        let stack = UIStackView(arrangedSubviews: [flightCard, stayCard])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        tripDetailsStack.addArrangedSubview(stack)
    }


        func setupDayTabs() {
            dayTabs.removeAllSegments()
            let days = ["Day 1", "Day 2", "Day 3"]

            for (index, day) in days.enumerated() {
                dayTabs.insertSegment(withTitle: day, at: index, animated: false)
            }

            dayTabs.selectedSegmentIndex = 1
            dayTabs.selectedSegmentTintColor = .systemOrange
        }

        func setupItineraryList() {
            itineraryStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

            itineraryStack.axis = .vertical
            itineraryStack.spacing = 16
            itineraryStack.distribution = .equalSpacing

            let locations = [
                ("Louvre", "6/10", "glass"),
                ("Eiffel Tower", "VOTE", "paris"),
                ("Paris Catacombs", "VOTE", "catacombs"),
                ("Florence Kahn", "2/10", "florence")
            ]

            for location in locations {
                let item = createItineraryItem(title: location.0, votes: location.1, imageName: location.2)
                itineraryStack.addArrangedSubview(item)
            }
        }

        func createItineraryItem(title: String, votes: String, imageName: String) -> UIView {
            let container = UIStackView()
            container.axis = .horizontal
            container.alignment = .center
            container.spacing = 16

            let labelsStack = UIStackView()
            labelsStack.axis = .vertical
            labelsStack.alignment = .leading
            labelsStack.spacing = 4

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)

            // Conditionally create either a button or label for the votes
            let voteView: UIView

            if votes == "VOTE" {
                // Create a button for voting
                let voteButton = UIButton(type: .system)
                voteButton.setTitle(votes, for: .normal)
                voteButton.setTitleColor(.white, for: .normal)
                voteButton.backgroundColor = .systemOrange
                voteButton.layer.cornerRadius = 10
                voteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                voteButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                voteView = voteButton
            } else {
                // Create a label for displaying the fraction or any other text
                let voteLabel = UILabel()
                voteLabel.text = votes
                voteLabel.font = UIFont.systemFont(ofSize: 16)
                voteLabel.textColor = .black
                voteView = voteLabel
            }

            // Set the image for each item based on the imageName passed
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true

            // Add arranged subviews
            labelsStack.addArrangedSubview(titleLabel)
            labelsStack.addArrangedSubview(voteView) // Add the button or label
            container.addArrangedSubview(labelsStack)
            container.addArrangedSubview(imageView)

            return container
        }


        func setupBottomTabBar() {
            bottomTabBar.delegate = self

            // Tab bar items
            let homeItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
            let mapItem = UITabBarItem(title: nil, image: UIImage(systemName: "map"), tag: 1)
            let favoritesItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), tag: 2)
            let profileItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 3)

            bottomTabBar.items = [homeItem, mapItem, favoritesItem, profileItem]
            bottomTabBar.selectedItem = mapItem

            // Add orange dot indicator for selected tab
            let indicatorView = UIView()
            indicatorView.backgroundColor = .systemOrange
            indicatorView.layer.cornerRadius = 3
            indicatorView.translatesAutoresizingMaskIntoConstraints = false

            bottomTabBar.addSubview(indicatorView)

            NSLayoutConstraint.activate([
                indicatorView.centerXAnchor.constraint(equalTo: bottomTabBar.centerXAnchor),
                indicatorView.bottomAnchor.constraint(equalTo: bottomTabBar.bottomAnchor, constant: -8),
                indicatorView.widthAnchor.constraint(equalToConstant: 6),
                indicatorView.heightAnchor.constraint(equalToConstant: 6)
            ])
        }

        // Helper method to create card views
        func createCard(title: String, details: String, imageName: String) -> UIView {
            let card = UIView()
            card.backgroundColor = .systemGray6
            card.layer.cornerRadius = 12
            card.translatesAutoresizingMaskIntoConstraints = false

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            let detailsLabel = UILabel()
            detailsLabel.text = details
            detailsLabel.textColor = .gray
            detailsLabel.translatesAutoresizingMaskIntoConstraints = false

            let stack = UIStackView(arrangedSubviews: [titleLabel, detailsLabel])
            stack.axis = .vertical
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false

            card.addSubview(stack)

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
                stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
                stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8)
            ])

            return card
        }

        
    }

    // MARK: - UITabBarDelegate
    extension viewitineraryViewController: UITabBarDelegate {
        func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            // Update the orange dot position
            if let indicatorView = tabBar.subviews.last,
               let items = tabBar.items,
               let index = items.firstIndex(of: item),
               let tabBarButtons = tabBar.subviews.filter({ $0.isKind(of: NSClassFromString("UITabBarButton")!) }) as? [UIView] {

                let selectedButton = tabBarButtons[index]

                UIView.animate(withDuration: 0.3) {
                    indicatorView.center.x = selectedButton.center.x
                }
            }
        }
    }
