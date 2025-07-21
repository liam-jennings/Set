//
//  CardView.swift
//  Set
//
//  Created by Liam Jennings on 19/7/2025.
//

import UIKit

class CardView: UIView {
    
    var card: SetCard? { didSet { setNeedsDisplay(); setNeedsLayout() }}
    
    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(frame: CGRect, card: SetCard?) {
        self.init(frame: frame)
        self.card = card
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentMode = .redraw
        backgroundColor = .clear
        
    }
    
    // MARK: - Drawing logic
    override func draw(_ rect: CGRect) {
        
        // Draw the card background
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        // Draw the symbol(s)
        if let card = card {
            drawCardSymbols(for: card, in: rect)
        }
        
        drawSelectionBorder()
    }
    
    private func drawCardSymbols(for card: SetCard, in rect: CGRect) {
        let rects = symbolRects(for: card.count, in: rect)
        
        rects.forEach { drawSymbol(for: card, in: $0) }
    }
    
    private func symbolRects(for count: Count, in rect: CGRect) -> [CGRect] {
        // Always calculate based on 3 symbols for consistent sizing
        let totalSymbols = 3
        let gapRatio: CGFloat = 0.25 // gaps are 1/4 the width of symbols
        
        let availableWidth = rect.width * 0.9 // leave some padding
        let symbolWidth = availableWidth / (CGFloat(totalSymbols) + CGFloat(totalSymbols + 1) * gapRatio)
        let gapWidth = symbolWidth * gapRatio
        
        // Symbol height - maintain same aspect ratio as the card
        let cardAspectRatio = rect.width / rect.height
        let symbolHeight = symbolWidth / cardAspectRatio
        
        // Calculate actual number of symbols to draw
        let actualCount = count.rawValue
        
        var rects: [CGRect] = []
        
        // Calculate starting X position to center the symbols
        let totalUsedWidth = CGFloat(actualCount) * symbolWidth + CGFloat(actualCount + 1) * gapWidth
        let startX = rect.midX - totalUsedWidth / 2
        let symbolY = rect.midY - symbolHeight / 2
        
        // Create rectangles for each symbol
        for i in 0..<actualCount {
            let x = startX + gapWidth + CGFloat(i) * (symbolWidth + gapWidth)
            let symbolRect = CGRect(x: x, y: symbolY, width: symbolWidth, height: symbolHeight)
            rects.append(symbolRect)
        }
        
        return rects
    }
    
    private func drawSymbol(for card: SetCard, in rect: CGRect) {
        let path = pathForSymbol(card.shape, in: rect)
        
        colour(for: card.colour).setFill()
        colour(for: card.colour).setStroke()
        path.lineWidth = max(0.5, min(2.0, rect.width / 50)) // Scale line width with card size
        
        applyShading(card.shading, to: path, in: rect)
        path.stroke()
        
    }
    
    private func pathForSymbol(_ shape: Shape, in rect: CGRect) -> UIBezierPath {
        switch shape {
            case .diamond:
                return getDiamondPath(in: rect)
            case .oval:
                return getOvalPath(in: rect)
            case .squiggle:
                return getSquigglePath(in: rect)
        }
    }
    
    private func getDiamondPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.close()
        return path
    }
    
    private func getOvalPath(in rect: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect, cornerRadius: rect.width)
    }
    
    private func getSquigglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        // Define the squiggle as relative proportions of the rect
        let width = rect.width
        let height = rect.height
        let minX = rect.minX
        let minY = rect.minY
        
        // Helper function to create points relative to the rect
        func point(x: CGFloat, y: CGFloat) -> CGPoint {
            return CGPoint(x: minX + x * width, y: minY + y * height)
        }
        
        // Create the squiggle path using relative coordinates (0.0 to 1.0)
        path.move(to: point(x: 0.95, y: 0.21))
        
        path.addCurve(
            to: point(x: 0.57, y: 0.77),
            controlPoint1: point(x: 1.02, y: 0.53),
            controlPoint2: point(x: 0.82, y: 0.87)
        )
        
        path.addCurve(
            to: point(x: 0.25, y: 0.76),
            controlPoint1: point(x: 0.48, y: 0.73),
            controlPoint2: point(x: 0.38, y: 0.60)
        )
        
        path.addCurve(
            to: point(x: 0.05, y: 0.57),
            controlPoint1: point(x: 0.09, y: 0.94),
            controlPoint2: point(x: 0.05, y: 0.83)
        )
        
        path.addCurve(
            to: point(x: 0.33, y: 0.17),
            controlPoint1: point(x: 0.04, y: 0.31),
            controlPoint2: point(x: 0.17, y: 0.14)
        )
        
        path.addCurve(
            to: point(x: 0.81, y: 0.20),
            controlPoint1: point(x: 0.54, y: 0.22),
            controlPoint2: point(x: 0.56, y: 0.45)
        )
        
        path.addCurve(
            to: point(x: 0.95, y: 0.21),
            controlPoint1: point(x: 0.87, y: 0.14),
            controlPoint2: point(x: 0.92, y: 0.10)
        )
        
        path.close()
        return path
    }
    
    private func applyShading(_ shading: Shading, to path: UIBezierPath, in rect: CGRect) {
        switch shading {
        case .solid:
            path.fill()
        case .striped:
            stripe(path: path, in: rect)
        case .outlined:
            break
        }
    }
    
    private func stripe(path: UIBezierPath, in rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.saveGState()
        path.addClip()
        
        let stripeSpacing = max(2, rect.width / 20) // Scale stripe spacing with card size
        let stripeCount = Int(rect.width / stripeSpacing)
        
        for i in 0..<stripeCount {
            let x = rect.minX + CGFloat(i) * stripeSpacing
            let stripePath = UIBezierPath()
            stripePath.move(to: CGPoint(x: x, y: rect.minY))
            stripePath.addLine(to: CGPoint(x: x, y: rect.maxY))
            stripePath.lineWidth = max(0.5, stripeSpacing / 4)
            stripePath.stroke()
        }
        
        context.restoreGState()
    }
    
    private func drawSelectionBorder() {
        if isSelected {
            let borderPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius)
            UIColor.systemBlue.setStroke()
            borderPath.lineWidth = 3.0
            borderPath.stroke()
        }
    }
}

// MARK: - CardView Extensions
extension CardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    
    private var cornerRadius: CGFloat {
        return bounds.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private func colour(for cardColor: Colour) -> UIColor {
        switch cardColor {
        case .red: return .systemRed
        case .green: return .systemGreen
        case .purple: return .systemPurple
        }
    }
}

#Preview {
    CardView()
}
