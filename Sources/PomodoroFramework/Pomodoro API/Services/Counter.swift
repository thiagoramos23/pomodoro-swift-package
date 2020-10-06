//
//  PomodoroCounter.swift
//  MyPomodoro
//
//  Created by Thiago Ramos on 09/08/20.
//

import Foundation

protocol InternalCounter {
    var dispatchEventHandler: (() -> Void)? { get set }
    func resume()
    func suspend()
}

class Counter: InternalCounter {
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    var interval: TimeInterval
    
    private lazy var timer: DispatchSourceTimer = {
        let dispatchtTimer = DispatchSource.makeTimerSource()
        dispatchtTimer.schedule(deadline: .now(), repeating: self.interval)
        dispatchtTimer.setEventHandler { [weak self] in
            self?.dispatchEventHandler?()
        }
        
        return dispatchtTimer
    }()
    var dispatchEventHandler: (() -> Void)?
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
    }
        
    func resume() {
        if state == .resumed {
            return
        }
        
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        
        state = .suspended
        timer.suspend()
    }
}
