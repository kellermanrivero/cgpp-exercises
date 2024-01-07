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
    
    func numberOfLines(size: CGSize) -> (x: Int, y: Int) {
        let x = numberOfLines
        let aspectRatio = size.width / size.height
        let y = Int(CGFloat(numberOfLines) / aspectRatio )
        return (x, y)
    }
    
    func scaleFactor(size: CGSize) -> (x: CGFloat, y: CGFloat) {
        let (xLines, yLines) = numberOfLines(size: size)
        let x = (size.width) / CGFloat(xLines)
        let y = (size.height) / CGFloat(yLines)
        return (x, y)
    }
    
    func origin(size: CGSize) -> (x: CGFloat, y: CGFloat) {
        let (xLines, yLines) = numberOfLines(size: size)
        let (scaleX, scaleY) = scaleFactor(size: size)
        let x = scaleX * (CGFloat(xLines) / 2)
        let y = scaleY * (CGFloat(yLines) / 2)
        return (x, y)
    }
    
    func scaleTransform(size: CGSize) -> CGAffineTransform {
        let (scaleX, scaleY) = scaleFactor(size: size)
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    func drawSquares(context: GraphicsContext, size: CGSize) {
        let (xLines, yLines) = numberOfLines(size: size)
        let transform = scaleTransform(size: size)
        for line in 0...xLines {
            let s = CGFloat(line)
            var path = Path()
            path.move(to: CGPoint(x: s, y: 0))
            path.addLine(to: CGPoint(x: s, y: size.width))
            path = path.applying(transform)
            context.stroke(path, with: .color(.gray), lineWidth: 0.2)
        }
        
        for line in 0...yLines {
            let s = CGFloat(line)
            var path = Path()
            path = Path()
            path.move(to: CGPoint(x: 0, y: s))
            path.addLine(to: CGPoint(x: size.height, y: s))
            path = path.applying(transform)
            context.stroke(path, with: .color(.gray), lineWidth: 0.2)
        }
    }
    
    func drawXAxis(context: GraphicsContext, size: CGSize) {
        let (_, yOrigin) = origin(size: size)
        let (xLines, _) = numberOfLines(size: size)
        let xDelta = xLines/2
        let (xScaleFactor, _) = scaleFactor(size: size)
        var path = Path()
        path.move(to: CGPoint(x: 0, y: yOrigin))
        path.addLine(to: CGPoint(x: size.width, y: yOrigin))
        context.stroke(path, with: .color(.black), lineWidth: 1)
        
        if showRule {
            for i in 0...xLines {
                var rule = Path()
                let x = CGFloat(i) * xScaleFactor
                
                if showRuleLeyend {
                    context.draw(
                        Text(String(i-xDelta))
                            .font(.system(size: 8))
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
        let (_, yLines) = numberOfLines(size: size)
        let (_, yScaleFactor) = scaleFactor(size: size)
        let yDelta = yLines/2
        var path = Path()
        path.move(to: CGPoint(x: xOrigin, y: 0))
        path.addLine(to: CGPoint(x: xOrigin, y: size.height))
        context.stroke(path, with: .color(.black), lineWidth: 1)
        
        if showRule {
            for i in 0...yLines {
                var rule = Path()
                let y = CGFloat(i) * yScaleFactor
                
                if showRuleLeyend {
                    context.draw(
                        Text(String(i-yDelta))
                            .font(.system(size: 8))
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
    GraphPaperView(showRule: true, showRuleLeyend: true)
}
