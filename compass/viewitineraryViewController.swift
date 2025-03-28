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
            setupConstraints()
        }

        func setupConstraints() {
            // Pin scrollView to superview
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

            // Pin contentView to scrollView's content layout guide
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
            ])

            setupSections()
        }

        func setupSections() {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(stack)

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])

            stack.addArrangedSubview(createHeader())
            stack.addArrangedSubview(createTripDetails())
            stack.addArrangedSubview(createDayTabs())
            stack.addArrangedSubview(createItineraryList())
        }

        func createHeader() -> UILabel {
            let headerLabel = UILabel()
            headerLabel.text = "My Trip to Paris \u{1F1EB}\u{1F1F7}"
            headerLabel.font = UIFont.boldSystemFont(ofSize: 28)
            headerLabel.textAlignment = .center
            return headerLabel
        }

        func createTripDetails() -> UIStackView {
            let flightCard = createCard(title: "Flights", details: "SFO -> CDG")
            let stayCard = createCard(title: "Stays", details: "Condo in Les Halles")

            let stack = UIStackView(arrangedSubviews: [flightCard, stayCard])
            stack.axis = .horizontal
            stack.spacing = 16
            stack.distribution = .fillEqually
            return stack
        }

        func createDayTabs() -> UISegmentedControl {
            let dayTabs = UISegmentedControl(items: ["Day 1", "Day 2", "Day 3"])
            dayTabs.selectedSegmentIndex = 1
            return dayTabs
        }

        func createItineraryList() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 10

            let locations = [
                ("Louvre", "6/10"),
                ("Eiffel Tower", "VOTE"),
                ("Paris Catacombs", "VOTE"),
                ("Florence Kahn", "2/10")
            ]

            for (title, votes) in locations {
                stack.addArrangedSubview(createItineraryItem(title: title, votes: votes))
            }

            return stack
        }

        func createCard(title: String, details: String) -> UIView {
            let card = UIView()
            card.backgroundColor = .systemGray6
            card.layer.cornerRadius = 12

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)

            let detailsLabel = UILabel()
            detailsLabel.text = details
            detailsLabel.textColor = .gray

            let stack = UIStackView(arrangedSubviews: [titleLabel, detailsLabel])
            stack.axis = .vertical
            stack.spacing = 4

            card.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
                stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
                stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10),
                stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10)
            ])

            return card
        }

        func createItineraryItem(title: String, votes: String) -> UIView {
            let item = UIView()
            item.backgroundColor = .white
            item.layer.cornerRadius = 12
            item.layer.borderWidth = 1
            item.layer.borderColor = UIColor.systemGray4.cgColor

            let titleLabel = UILabel()
            titleLabel.text = title

            let voteLabel = UILabel()
            voteLabel.text = votes
            voteLabel.textColor = .systemOrange

            let stack = UIStackView(arrangedSubviews: [titleLabel, voteLabel])
            stack.axis = .horizontal
            stack.spacing = 10

            item.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: item.topAnchor, constant: 8),
                stack.leadingAnchor.constraint(equalTo: item.leadingAnchor, constant: 8),
                stack.trailingAnchor.constraint(equalTo: item.trailingAnchor, constant: -8),
                stack.bottomAnchor.constraint(equalTo: item.bottomAnchor, constant: -8)
            ])

            return item
        }
    }
