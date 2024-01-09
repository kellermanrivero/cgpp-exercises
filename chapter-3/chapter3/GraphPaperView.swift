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

struct Edge {
    var a: Int
    var b: Int
}

struct Vertex {
    var x: Double
    var y: Double
    var z: Double
}

struct VertexBuffer {
    var vertices: [Vertex]
    var edges: [Edge]
}

struct GraphPaperView: View {
    @State
    var config: GraphPaperConfig
    
    @State
    var data: VertexBuffer
    
    private let numberOfLines = 20
    
    init() {
        data = VertexBuffer(vertices: [], edges: [])
        config = GraphPaperConfig(x: GraphPaperConfigAxis(min: -5, max: 5),
                                  y: GraphPaperConfigAxis(min: -5, max: 5),
                                  rule: true,
                                  legend: true)
    }
    
    init(config: GraphPaperConfig, data: VertexBuffer) {
        self.data = data
        self.config = config
    }
    
    var body: some View {
        Canvas { context, size in
            drawSquares(context: context, size: size)
            drawXAxis(context: context, size: size)
            drawYAxis(context: context, size: size)
            var points: [CGPoint] = []
            for vertex in data.vertices {
                let point = CGPoint(x: vertex.x/vertex.z, y: vertex.y/vertex.z)
                points.append(point)
                drawVertex(context: context, size: size, point: point)
            }
            
            for edge in data.edges {
                let from = points[edge.a]
                let to = points[edge.b]
                drawEdge(context: context, size: size, from: from, to: to)
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
    
    func drawVertex(context: GraphicsContext, size: CGSize, point: CGPoint) {
        let (originX, originY) = origin(size: size)
        let (scaleX, scaleY) = scaleFactor(size: size)
        let transform = CGAffineTransform(translationX: originX, y: originY)
            .scaledBy(x: scaleX, y: -scaleY)
        
        var dot = Path()
        dot.addEllipse(in: CGRect(origin: CGPoint(x: point.x - 0.025, y: point.y - 0.025), size: CGSize(width: 0.05, height: 0.05)))
        dot = dot.applying(transform)
        context.fill(dot, with: .color(.purple))
    }
    
    func drawEdge(context: GraphicsContext, size: CGSize, from: CGPoint, to: CGPoint) {
        let (originX, originY) = origin(size: size)
        let (scaleX, scaleY) = scaleFactor(size: size)
        let transform = CGAffineTransform(translationX: originX, y: originY)
            .scaledBy(x: scaleX, y: -scaleY)
        
        var line = Path()
        line.move(to: from)
        line.addLine(to: to)
        line = line.applying(transform)
        context.stroke(line, with: .color(.purple), style: StrokeStyle(lineWidth: 1, dash: [5]))
    }
}

#Preview {
    GraphPaperView(config: GraphPaperConfig(
                        x: GraphPaperConfigAxis(min: -3, max: 3),
                        y: GraphPaperConfigAxis(min: -3, max: 3),
                        rule: true,
                        legend: true),
                   data: VertexBuffer(vertices: [
                        Vertex(x: -0.5, y: -0.5, z: 2.5),
                        Vertex(x: -0.5, y:  0.5, z: 2.5),
                        Vertex(x:  0.5, y:  0.5, z: 2.5),
                        Vertex(x:  0.5, y: -0.5, z: 2.5),
                        Vertex(x: -0.5, y: -0.5, z: 3.5),
                        Vertex(x: -0.5, y:  0.5, z: 3.5),
                        Vertex(x:  0.5, y:  0.5, z: 3.5),
                        Vertex(x:  0.5, y: -0.5, z: 3.5)
                   ], edges: [
                        Edge(a: 0, b: 1),
                        Edge(a: 1, b: 2),
                        Edge(a: 2, b: 3),
                        Edge(a: 3, b: 0),
                        Edge(a: 0, b: 4),
                        Edge(a: 1, b: 5),
                        Edge(a: 2, b: 6),
                        Edge(a: 3, b: 7),
                        Edge(a: 4, b: 5),
                        Edge(a: 5, b: 6),
                        Edge(a: 6, b: 7),
                        Edge(a: 7, b: 4),
                    ])
    )
}
