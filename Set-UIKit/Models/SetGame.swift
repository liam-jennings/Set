//
//  SetGame.swift
//  Set
//
//  Created by Liam Jennings on 20/7/2025.
//

import Foundation

class SetGame {
    
    // MARK: - Game State
    private var deck = [SetCard]()
    var currentCards: [SetCard?] = [] // optional as nil represents empty card slot
    private var selectedCards: Set<SetCard> = []
    private var matchedCards: Set<SetCard> = []
    var isFailedMatch: Bool = false
    
    var score: Int = 0
    
    // MARK: - Game Constants
    private static let initialCardDeals: Int = 4
    private static let cardsPerDeal: Int = 3
    
    init() {
        newGame()
    }
    
    private func newGame() {
        deck = []
        currentCards = []
        score = 0
        
        deck = Shape.allCases.flatMap { shape in
            Colour.allCases.flatMap { colour in
                Shading.allCases.flatMap { shading in
                    Count.allCases.map { count in
                        SetCard(shape: shape, colour: colour, shading: shading, count: count)
                    }}}}
        
        deck.shuffle()
        
        (0..<Self.initialCardDeals).forEach { _ in
            dealCards()
        }
    }
    
    func dealCards() {
        var cardsDealt = 0
        
        // Fill empty slots first
        for i in currentCards.indices {
            guard currentCards[i] == nil && !deck.isEmpty && cardsDealt < Self.cardsPerDeal else { continue }
            currentCards[i] = deck.removeFirst()
            cardsDealt += 1
        }
        
        while cardsDealt < Self.cardsPerDeal && !deck.isEmpty {
            currentCards.append(deck.removeFirst())
            cardsDealt += 1
        }
    }
    
    func selectCard(_ card: SetCard) {
        if selectedCards.contains(card) {
            // Card is already selected, so unselect it
            selectedCards.remove(card)
            isFailedMatch = false
        } else if selectedCards.count == 3 {
            // Already have 3 selected, clear all and select this one
            selectedCards.removeAll()
            selectedCards.insert(card)
            isFailedMatch = false
        } else {
            // Add to selection (we have fewer than 3 selected)
            selectedCards.insert(card)
            isFailedMatch = false
        }
        
        if selectedCards.count == 3 {
            if isValidSet(Array(selectedCards)) {
                // Move matched cards into matchedCards
                for card in selectedCards {
                    matchedCards.insert(card)
                }
                
                // Remove matched cards from currentCards (replace with nil)
                for i in currentCards.indices {
                    if let card = currentCards[i], selectedCards.contains(card) {
                        currentCards[i] = nil
                    }
                }
                
                // Clear selection
                selectedCards.removeAll()
                
                
                isFailedMatch = false
                
            } else {
                isFailedMatch = true
            }
        }
    }
    
    // Helper method to check if a card is selected
    func isCardSelected(_ card: SetCard) -> Bool {
        return selectedCards.contains(card)
    }
    
    private func clearSelection() {
        selectedCards.removeAll()
    }
    
    private func isValidSet(_ cards: [SetCard]) -> Bool {
        return true
    }
}

// Extension for Array to provide meaningful functionality for the Set game
extension Array where Element == SetCard {
    // Method that takes a closure to find cards matching a condition
    func findCards(matching condition: (SetCard) -> Bool) -> [SetCard] {
        return self.filter(condition)
    }
    
    // Remove all cards that match a given condition
    mutating func removeCards(matching condition: (SetCard) -> Bool) {
        self.removeAll(where: condition)
    }
}
