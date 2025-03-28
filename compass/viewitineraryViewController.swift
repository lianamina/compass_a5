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
            let headerLabel = UILabel()
            headerLabel.text = "My Trip to Paris 🇫🇷"
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
            let flightCard = createCard(title: "Flights", details: "SFO -> CDG", imageName: "flight")
            let stayCard = createCard(title: "Stays", details: "Condo in Les Halles", imageName: "stay")

            let stack = UIStackView(arrangedSubviews: [flightCard, stayCard])
            stack.axis = .horizontal
            stack.spacing = 16
            stack.distribution = .fillEqually
            stack.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(stack)

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
                stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
        }

        func setupDayTabs() {
            let dayTabs = UISegmentedControl(items: ["Day 1", "Day 2", "Day 3"])
            dayTabs.selectedSegmentIndex = 1
            dayTabs.selectedSegmentTintColor = .systemOrange
            dayTabs.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(dayTabs)

            NSLayoutConstraint.activate([
                dayTabs.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 180),
                dayTabs.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                dayTabs.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
        }

        func setupItineraryList() {
            let itineraryStack = UIStackView()
            itineraryStack.axis = .vertical
            itineraryStack.spacing = 10
            itineraryStack.translatesAutoresizingMaskIntoConstraints = false

            let locations = [
                ("Louvre", "6/10", "louvre"),
                ("Eiffel Tower", "VOTE", "eiffel"),
                ("Paris Catacombs", "VOTE", "catacombs"),
                ("Florence Kahn", "2/10", "florence")
            ]

            for location in locations {
                itineraryStack.addArrangedSubview(createItineraryItem(title: location.0, votes: location.1, imageName: location.2))
            }

            contentView.addSubview(itineraryStack)

            NSLayoutConstraint.activate([
                itineraryStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 240),
                itineraryStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                itineraryStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                itineraryStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }

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

        func createItineraryItem(title: String, votes: String, imageName: String) -> UIView {
            let item = UIView()
            item.backgroundColor = .white
            item.layer.cornerRadius = 12
            item.layer.borderWidth = 1
            item.layer.borderColor = UIColor.systemGray4.cgColor
            item.translatesAutoresizingMaskIntoConstraints = false

            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.translatesAutoresizingMaskIntoConstraints = false

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            let voteButton = UIButton(type: .system)
            voteButton.setTitle(votes, for: .normal)
            voteButton.backgroundColor = .systemOrange
            voteButton.setTitleColor(.white, for: .normal)
            voteButton.layer.cornerRadius = 12
            voteButton.translatesAutoresizingMaskIntoConstraints = false

            let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, voteButton])
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = 10
            stack.translatesAutoresizingMaskIntoConstraints = false

            item.addSubview(stack)

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: item.topAnchor, constant: 8),
                stack.bottomAnchor.constraint(equalTo: item.bottomAnchor, constant: -8),
                stack.leadingAnchor.constraint(equalTo: item.leadingAnchor, constant: 8),
                stack.trailingAnchor.constraint(equalTo: item.trailingAnchor, constant: -8)
            ])

            return item
        }
    
    func setupBottomTabBar() {
              // Configure tab bar
              bottomTabBar.delegate = self
              
              // Create tab bar items
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
