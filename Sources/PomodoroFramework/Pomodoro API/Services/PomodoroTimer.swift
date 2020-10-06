//
//  PomodoroCounter.swift
//  MyPomodoro
//
//  Created by Thiago Ramos on 11/08/20.
//

import Foundation

protocol CountdownTimer {
    func countdown(completion: @escaping (TimeInterval) -> Void)
    func stop()
    func reset()
}

class PomodoroTimer: CountdownTimer  {
    var timeInSeconds: TimeInterval
    var counter: InternalCounter
    
    private var backupTimeInSeconds: TimeInterval

    init(timeInSeconds: TimeInterval, counter: InternalCounter) {
        self.timeInSeconds = timeInSeconds
        self.backupTimeInSeconds = timeInSeconds
        self.counter  = counter
    }
    
    func stop() {
        self.counter.suspend()
    }
    
    func reset() {
        self.stop()
        self.timeInSeconds = self.backupTimeInSeconds
    }
        
    func countdown(completion: @escaping (TimeInterval) -> Void) {
        self.counter.dispatchEventHandler = { [weak self] in
            completion(self?.subtract(seconds: 1) ?? 0)
            self?.stopWhenReachesZeroSeconds()
        }

        self.counter.resume()
    }
        
    fileprivate func subtract(seconds: Int) -> TimeInterval {
        self.timeInSeconds -= 1
        return self.timeInSeconds
    }

    fileprivate func stopWhenReachesZeroSeconds() {
        if self.timeInSeconds == 0 {
            self.stop()
        }
    }

}
