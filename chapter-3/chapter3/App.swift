//
//  App.swift
//  Chapter3 
//
//  Created by Kellerman Rivero on 7/1/24.
//

import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
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
    }
}
