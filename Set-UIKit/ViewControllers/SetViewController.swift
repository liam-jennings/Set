//
//  ViewController.swift
//  Set
//
//  Created by Liam Jennings on 19/7/2025.
//

import UIKit

class SetViewController: UIViewController {
    
    // MARK: - Game
    private var game = SetGame()
    
    // MARK: - UI Components
    private let scoreLabel = UILabel()
    private let cardContainerView = UIView()
    private let deckView = UIView()
    private let discardView = UIView()
    private let newGameButton = UIButton()
    
    // MARK: - Dynamic Layout Properties
    private var cardViews: [CardView] = []
    private var grid: Grid!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        grid = Grid(layout: .aspectRatio(LayoutConstants.cardRatio), frame: .zero)
        updateViewFromModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupScoreLabel()
        setupCardContainer()
        setupDeck()
        setupDiscardPile()
        setupNewGameButton()
        
    }
    
    private func setupScoreLabel() {
        scoreLabel.text = "Score: 0"
        scoreLabel.font = .systemFont(ofSize: 24, weight: .bold)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .label
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
    }
    
    private func setupCardContainer() {
        cardContainerView.backgroundColor = .secondarySystemBackground
        cardContainerView.layer.cornerRadius = LayoutConstants.cornerRadius
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardContainerView)
    }
    
    private func setupDeck() {
        deckView.backgroundColor = .systemBrown
        deckView.layer.cornerRadius = LayoutConstants.cornerRadius
        deckView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deckView)
    }
    
    private func setupDiscardPile() {
        discardView.backgroundColor = .systemGray5
        discardView.layer.cornerRadius = LayoutConstants.cornerRadius
        discardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(discardView)
    }
    
    private func setupNewGameButton() {
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        newGameButton.backgroundColor = .systemBlue
        newGameButton.setTitleColor(.white, for: .normal)
        newGameButton.layer.cornerRadius = LayoutConstants.cornerRadius
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        view.addSubview(newGameButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstants.spacing),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.spacing),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.spacing),
            
            // New Game Button - right half of screen
            newGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -LayoutConstants.spacing),
            newGameButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: LayoutConstants.spacing),
            newGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.spacing),
            newGameButton.heightAnchor.constraint(equalToConstant: 85),
            
            // Deck View - left quarter of screen
            deckView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -LayoutConstants.spacing),
            deckView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.spacing),
            deckView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25, constant: -LayoutConstants.spacing * 1.5),
            deckView.heightAnchor.constraint(equalToConstant: 85),
            
            // Discard View - second quarter of screen
            discardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -LayoutConstants.spacing),
            discardView.leadingAnchor.constraint(equalTo: deckView.trailingAnchor, constant: LayoutConstants.spacing),
            discardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25, constant: -LayoutConstants.spacing * 1.5),
            discardView.heightAnchor.constraint(equalToConstant: 85),
            
            cardContainerView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: LayoutConstants.spacing),
            cardContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.spacing),
            cardContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.spacing),
            cardContainerView.bottomAnchor.constraint(equalTo: deckView.topAnchor, constant: -LayoutConstants.spacing)
            
        ])
    }
    
    // MARK: - View Updates
    private func updateViewFromModel() {
        updateGrid()
        updateScore()
        updateCardViews()
    }
    
    private func updateGrid() {
        grid.frame = cardContainerView.bounds
        let actualCardCount = game.currentCards.compactMap { $0 }.count
        // Always show at least 12 card spots
        grid.cellCount = max(actualCardCount, 12)
    }
    
    private func updateScore() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    // Modify your existing updateCardViews method
    private func updateCardViews() {
        let currentCards = game.currentCards.compactMap { $0 }
        
        // Remove excess card views if we have more views than cards
        while cardViews.count > currentCards.count {
            cardViews.removeLast().removeFromSuperview()
        }
        
        // Add new card views if we have fewer views than cards
        while cardViews.count < currentCards.count {
            let cardIndex = cardViews.count
            let cardView = CardView(frame: .zero, card: currentCards[cardIndex])
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardContainerView.addSubview(cardView)
            cardViews.append(cardView)
        }
        
        // Position and configure all card views
        for (index, cardView) in cardViews.enumerated() {
            if let cellFrame = grid[index] {
                let padding: CGFloat = 4
                cardView.frame = cellFrame.insetBy(dx: padding, dy: padding)
                
                // Set selection state
                if let card = cardView.card {
                    cardView.isSelected = game.isCardSelected(card)
                }
                
                // Remove old gesture recognizers
                cardView.gestureRecognizers?.removeAll()
                
                // Add tap gesture
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
                cardView.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func newGameTapped() {
        // For new game, completely clear card views since we're getting entirely new cards
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()
        
        game = SetGame()
        updateViewFromModel()
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedCardView = gesture.view as? CardView,
              let card = tappedCardView.card else { return }
        
        game.selectCard(card)
        updateViewFromModel()
    }
}

extension SetViewController {
    struct LayoutConstants {
        static let spacing: CGFloat = 20
        static let cornerRadius: CGFloat = 8
        static let cardRatio: CGFloat = (2.5/3.5)
    }
}

// MARK: - Preview

#Preview {
    SetViewController()
}
