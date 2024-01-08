//
//  GraphPaperView.swift
//  Chapter3
//
//  Created by Kellerman Rivero on 7/1/24.
//

import SwiftUI

struct GraphPaperConfigAxis {
    var min: Int
    var max: Int
}

struct GraphPaperConfig {
    var x: GraphPaperConfigAxis
    var y: GraphPaperConfigAxis
    var rule: Bool
    var legend: Bool
    
    func numberOfLines() -> (x: Int, y: Int) {
        let x = x.max - x.min
        let y = y.max - y.min
        return (x, y)
    }
}

struct DataPoint {
    var x: Double
    var y: Double
}

struct GraphPaperView: View {
    @State
    var config: GraphPaperConfig
    
    @State
    var data: [DataPoint]
    
    private let numberOfLines = 20
    
    init() {
        data = []
        config = GraphPaperConfig(x: GraphPaperConfigAxis(min: -10, max: 10),
                                  y: GraphPaperConfigAxis(min: -10, max: 10),
                                  rule: true,
                                  legend: true)
    }
    
    init(config: GraphPaperConfig, data: [DataPoint]) {
        self.data = data
        self.config = config
    }
    
    var body: some View {
        Canvas { context, size in
            drawSquares(context: context, size: size)
            drawXAxis(context: context, size: size)
            drawYAxis(context: context, size: size)
            var previousPoint: CGPoint?
            for datum in data {
                let point = CGPoint(x: datum.x, y: datum.y)
                drawPoint(context: context, size: size, point: point, previousPoint: previousPoint)
                previousPoint = point
            }
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(.white)
    }
    
    func scaleFactor(size: CGSize) -> (x: CGFloat, y: CGFloat) {
        let (xLines, yLines) = config.numberOfLines()
        let x = (size.width) / CGFloat(xLines)
        let y = (size.height) / CGFloat(yLines)
        return (x, y)
    }
    
    func origin(size: CGSize) -> (x: CGFloat, y: CGFloat) {
        let (scaleX, scaleY) = scaleFactor(size: size)
        let x = scaleX * (CGFloat(abs(config.x.min)))
        let y = scaleY * (CGFloat(abs(config.y.min)))
        return (x, y)
    }
    
    func drawSquares(context: GraphicsContext, size: CGSize) {
        let (xLines, yLines) = config.numberOfLines()
        let (scaleX, scaleY) = scaleFactor(size: size)
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
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
        let (xLines, _) = config.numberOfLines()
        let xDelta = abs(config.x.min)
        let (xScaleFactor, _) = scaleFactor(size: size)
        var path = Path()
        path.move(to: CGPoint(x: 0, y: yOrigin))
        path.addLine(to: CGPoint(x: size.width, y: yOrigin))
        context.stroke(path, with: .color(.black), lineWidth: 1)
        
        if config.rule {
            for i in 0...xLines {
                var rule = Path()
                let x = CGFloat(i) * xScaleFactor
                let label = i-xDelta;
                
                if config.legend && label != 0 {
                    context.draw(
                        Text(String(label))
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
        let (_, yLines) = config.numberOfLines()
        let (_, yScaleFactor) = scaleFactor(size: size)
        let yDelta = abs(config.y.min)
        var path = Path()
        path.move(to: CGPoint(x: xOrigin, y: 0))
        path.addLine(to: CGPoint(x: xOrigin, y: size.height))
        context.stroke(path, with: .color(.black), lineWidth: 1)
        
        if config.rule {
            for i in 0...yLines {
                var rule = Path()
                let y = CGFloat(i) * yScaleFactor
                let label = yDelta-i;
                
                if config.legend && label != 0 {
                    context.draw(
                        Text(String(label))
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
    
    func drawPoint(context: GraphicsContext, size: CGSize, point: CGPoint, previousPoint: CGPoint?) {
        let (originX, originY) = origin(size: size)
        let (scaleX, scaleY) = scaleFactor(size: size)
        let transform = CGAffineTransform(translationX: originX, y: originY)
            .scaledBy(x: scaleX, y: -scaleY)
        
        var dot = Path()
        dot.addEllipse(in: CGRect(origin: CGPoint(x: point.x - 0.05, y: point.y - 0.05), size: CGSize(width: 0.1, height: 0.1)))
        dot = dot.applying(transform)
        context.fill(dot, with: .color(.purple))
        
        if (previousPoint != nil) {
            var line = Path()
            line.move(to: previousPoint!)
            line.addLine(to: point)
            line = line.applying(transform)
            context.stroke(line, with: .color(.purple), style: StrokeStyle(lineWidth: 1, dash: [5]))
        }
    }
}

#Preview {
    GraphPaperView(config: GraphPaperConfig(
                        x: GraphPaperConfigAxis(min: -10, max: 10),
                        y: GraphPaperConfigAxis(min: -10, max: 10),
                        rule: true,
                        legend: true),
                   data: [ DataPoint(x: 1, y: 1),
                           DataPoint(x: 2, y: 2),
                           DataPoint(x: -3, y: -3) ]
    )
}
