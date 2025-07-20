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
    
    private var score: Int = 0
    
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
    
    private func dealCards() {
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
}
