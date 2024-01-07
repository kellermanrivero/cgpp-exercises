//
//  ContentView.swift
//  Chapter2
//
//  Created by Kellerman Rivero on 4/1/24.
//

import SwiftUI

extension View {
    func place() -> some View {
        return self
            .transformEffect(.init(scaleX: 4.8, y: 4.8))
            .transformEffect(.init(translationX: 48, y: 48))
    }
}

private struct AnimationValues {
    var angle = Angle.zero
}

struct ClockFace: Shape {
    func path(in rect: CGRect) -> Path {
        let clockOrigin = CGPoint(x: -10, y: -10)
        let clockSize = CGSize(width: 20, height: 20)
        let clockRectangle = CGRect(origin: clockOrigin, size: clockSize)
        let ellipse = Path(ellipseIn: clockRectangle)
        return ellipse
    }
}

struct ClockHand: Shape {
    var degrees = 180;
    func path(in rect: CGRect) -> Path {
        var path = Path();
        path.move(to: CGPoint(x: -0.3, y: -1.0))
        path.addLine(to: CGPoint(x: 0.3, y: -1.0))
        path.addLine(to: CGPoint(x: 0.2, y: 8.0))
        path.addLine(to: CGPoint(x: 0, y: 9.0))
        path.addLine(to: CGPoint(x: -0.2, y: 8.0))
        path.addLine(to: CGPoint(x: -0.3, y: -1.0))
        return path.applying(.init(rotationAngle: (CGFloat(degrees) * .pi / 180)))
    }
}

struct ContentView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State
    private var seconds: Int;
    @State
    private var minutes: Int;
    @State
    private var hours: Int;
    
    init() {
        let date = Date()
        let calendar = Calendar.current
        
        var _hours = calendar.component(.hour, from: date)
        if _hours > 12 {
            _hours = _hours - 12;
        }
        
        hours = _hours
        minutes = calendar.component(.minute, from: date)
        seconds = calendar.component(.second, from: date)
        print("Hours = " + String(hours))
        print("Minutes = " + String(minutes))
        print("Seconds = " + String(seconds))
    }
    
    var body: some View {
        ZStack {
            ClockFace()
                .fill()
                .place()
            
            // Seconds hand
            ClockHand(degrees: (seconds * 360 / 60) + 180)
                .transform(.init(scaleX: 0.5, y: 1))
                .fill(.green)
                .animation(.easeInOut(duration: 60), value: seconds)
                .place()
            
            // Minutes hand
            ClockHand(degrees: (minutes * 360 / 60) + 180)
                .fill(.black)
                .animation(.easeInOut(duration: 60), value: minutes)
                .place()
            
            // Hours hand
            ClockHand(degrees: (hours * 360 / 12) + 180)
                .transform(.init(scaleX: 0.7, y: 1.5))
                .fill(.red)
                .animation(.easeInOut(duration: 60), value: hours)
                .place()
            
            /*
            Canvas { context, size in
                let clockOrigin = CGPoint(x: -10, y: -10)
                let clockSize = CGSize(width: 20, height: 20)
                let clockRectangle = CGRect(origin: clockOrigin, size: clockSize)
                let ellipse = Path(ellipseIn: clockRectangle)
                    .place()
                
                context.fill(ellipse, with: .color(.green))
                
                let secondsHand = getClockHand()
                    .applying(.init(scaleX: 0.5, y: 1))
                    .applying(.init(rotationAngle: CGFloat((seconds * 360 / 60))))
                    .place()
                
                context.fill(secondsHand, with: .color(.red))
                
                let minutesHand = getClockHand()
                    .place()
                
                context.fill(minutesHand, with: .color(.blue))
                
                let hoursHand = getClockHand()
                    .applying(.init(scaleX: 1.7, y: 0.7))
                    .applying(.init(rotationAngle: 45))
                    .place()
                
                
                context.fill(hoursHand, with: .color(.black))
            }*/
            //.animation(.linear, value: seconds)
            //.frame(width: 640, height: 480)
            //.border(Color.blue)
        }
        .onAppear {
            seconds = seconds + 1
        }
        .onReceive(timer) { _ in
            seconds = seconds + 1
            if seconds > 59 {
                seconds = 0
                minutes = minutes + 1
            }
            
            if minutes > 59 {
                minutes = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
