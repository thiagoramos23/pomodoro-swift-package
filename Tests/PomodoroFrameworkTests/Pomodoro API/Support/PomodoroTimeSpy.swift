//
//  PomodoroTimeSpy.swift
//  MyPomodoroTests
//
//  Created by Thiago Ramos on 16/08/20.
//

import Foundation
@testable import PomodoroFramework

class PomodoroTimerSpy: CountdownTimer {    
    var completionCallCount: Int = 0
    var stopCallCount: Int = 0
    var resetCallCount: Int = 0
    var isStopped: Bool = false
    var seconds: TimeInterval
    
    init(seconds: TimeInterval) {
        self.seconds = seconds
    }
    
    func stop() {
        self.stopCallCount += 1
        self.isStopped = true
    }
    
    func reset() {
        self.resetCallCount += 1
        self.isStopped = true
    }

    func countdown(completion: @escaping (TimeInterval) -> Void) {
        self.isStopped = false
        while self.seconds > 0 && isNotStopped() {
            self.seconds -= 1
            self.completionCallCount += 1
            completion(seconds)
        }
    }
        
    private func isNotStopped() -> Bool {
        return !self.isStopped
    }
}
