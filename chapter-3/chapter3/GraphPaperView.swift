//
//  GraphPaperView.swift
//  Chapter3
//
//  Created by Kellerman Rivero on 7/1/24.
//

import SwiftUI

struct GraphPaperView: View {
    @State
    var showRule: Bool = true
    
    @State
    var showRuleLeyend: Bool = false
    
    private let numberOfLines = 20
    
    var body: some View {
        Canvas { context, size in
            drawSquares(context: context, size: size)
            drawXAxis(context: context, size: size)
            drawYAxis(context: context, size: size)
            
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(.white)
    }
    
    func scaleFactor(size: CGSize) -> (x: CGFloat, y: CGFloat) {
        let x = (size.width) / CGFloat(numberOfLines)
        let y = (size.height) / CGFloat(numberOfLines)
        return (x, y)
    }
    
    func origin(size: CGSize) -> (x: CGFloat, y: CGFloat) {
        let (scaleX, scaleY) = scaleFactor(size: size)
        let x = scaleX * (CGFloat(numberOfLines) / 2)
        let y = scaleY * (CGFloat(numberOfLines) / 2)
        return (x, y)
    }
    
    func scaleTransform(size: CGSize) -> CGAffineTransform {
        let (scaleX, scaleY) = scaleFactor(size: size)
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    func drawSquares(context: GraphicsContext, size: CGSize) {
        let transform = scaleTransform(size: size)
        for line in 0...numberOfLines {
            let s = CGFloat(line)
            var path = Path()
            path.move(to: CGPoint(x: s, y: 0))
            path.addLine(to: CGPoint(x: s, y: size.width))
            path = path.applying(transform)
            context.stroke(path, with: .color(.gray), lineWidth: 0.2)
            
            path = Path()
            path.move(to: CGPoint(x: 0, y: s))
            path.addLine(to: CGPoint(x: size.height, y: s))
            path = path.applying(transform)
            context.stroke(path, with: .color(.gray), lineWidth: 0.2)
        }
    }
    
    func drawXAxis(context: GraphicsContext, size: CGSize) {
        let (_, yOrigin) = origin(size: size)
        let (xScaleFactor, _) = scaleFactor(size: size)
        var path = Path()
        path.move(to: CGPoint(x: 0, y: yOrigin))
        path.addLine(to: CGPoint(x: size.width, y: yOrigin))
        context.stroke(path, with: .color(.black), lineWidth: 1)
        
        if showRule {
            for i in 0...numberOfLines {
                var rule = Path()
                let x = CGFloat(i) * xScaleFactor
                
                if showRuleLeyend {
                    context.draw(
                        Text(String(i-10))
                            .font(.footnote
                                .weight(.light))
                            .foregroundStyle(.gray),
                        at: CGPoint(x: x, y: yOrigin+15), anchor: .center)
                }
                
                rule.move(to: CGPoint(x: x, y: yOrigin - 5))
                rule.addLine(to: CGPoint(x: x, y: yOrigin + 5))
                context.stroke(rule, with: .color(.gray), lineWidth: 1)
            }
        }
    }
    
    func drawYAxis(context: GraphicsContext, size: CGSize) {
        let (xOrigin, _) = origin(size: size)
        let (_, yScaleFactor) = scaleFactor(size: size)
        var path = Path()
        path.move(to: CGPoint(x: xOrigin, y: 0))
        path.addLine(to: CGPoint(x: xOrigin, y: size.height))
        context.stroke(path, with: .color(.black), lineWidth: 1)
        
        if showRule {
            for i in 0...numberOfLines {
                var rule = Path()
                let y = CGFloat(i) * yScaleFactor
                
                if showRuleLeyend {
                    context.draw(
                        Text(String(i-10))
                            .font(.footnote
                                .weight(.light))
                            .foregroundStyle(.gray),
                        at: CGPoint(x: xOrigin+15, y: y), anchor: .center)
                }
                
                rule.move(to: CGPoint(x: xOrigin - 5, y: y))
                rule.addLine(to: CGPoint(x: xOrigin + 5, y: y))
                context.stroke(rule, with: .color(.gray), lineWidth: 1)
            }
        }
    }
}

#Preview {
    GraphPaperView(showRule: true, showRuleLeyend: false)
}
