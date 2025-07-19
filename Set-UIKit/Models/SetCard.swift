//
//  SetCard.swift
//  Set
//
//  Created by Liam Jennings on 19/7/2025.
//

struct SetCard : Equatable
{
    // Four attributes of a 'SetCard'
    let shape: Shape
    let colour: Colour
    let shading: Shading
    let count: Count
}

enum Shape: String, CaseIterable
{
    case triangle = "▲"
    case circle = "●"
    case square = "■"
}

enum Colour: CaseIterable
{
    case red
    case green
    case purple
}

enum Shading: CaseIterable
{
    case solid
    case striped
    case outlined
}

enum Count: Int, CaseIterable
{
    case one = 1
    case two = 2
    case three = 3
}
