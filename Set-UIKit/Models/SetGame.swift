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
    private var currentCards: [SetCard?] = [] // optional as nil represents empty card slot
    
    private var score: Int = 0
    
    // MARK: - Game Constants
    private static let initialCardDeals: Int = 4
    private static let cardsPerDeal: Int = 3
    
    init() {
        newGame()
    }
    
    private func newGame() {
        deck = []
        
        deck = Shape.allCases.flatMap { shape in
            Colour.allCases.flatMap { colour in
                Shading.allCases.flatMap { shading in
                    Count.allCases.map { count in
                        SetCard(shape: shape, colour: colour, shading: shading, count: count)
                    }
                }
            }
        }
        
        deck.shuffle()
    }
}
