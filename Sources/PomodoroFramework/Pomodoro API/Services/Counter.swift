//
//  PomodoroCounter.swift
//  MyPomodoro
//
//  Created by Thiago Ramos on 09/08/20.
//

import Foundation

public protocol InternalCounter {
    var dispatchEventHandler: (() -> Void)? { get set }
    func resume()
    func suspend()
}

public class Counter: InternalCounter {
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
    
    public init(interval: TimeInterval) {
        self.interval = interval
    }
    
    public deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
    }
        
    public func resume() {
        if state == .resumed {
            return
        }
        
        state = .resumed
        timer.resume()
    }
    
    public func suspend() {
        if state == .suspended {
            return
        }
        
        state = .suspended
        timer.suspend()
    }
}
