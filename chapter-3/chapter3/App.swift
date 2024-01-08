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
                                x: GraphPaperConfigAxis(min: -10, max: 10),
                                y: GraphPaperConfigAxis(min: -10, max: 10),
                                rule: true,
                                legend: true),
                           data: [ DataPoint(x: 1, y: 1), DataPoint(x: 2, y: 2) ]
            )
        }
    }
}
