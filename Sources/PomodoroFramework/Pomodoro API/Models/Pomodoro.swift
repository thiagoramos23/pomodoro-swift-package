//
//  File.swift
//  
//
//  Created by Thiago Ramos on 09/08/20.
//

import Foundation

public enum PomodoroState {
    case running
    case stopped
    case finished
}

public enum PomodoroType: Equatable {
    case workInterval
    case breakInterval
}

struct Pomodoro {
    private(set) var state: PomodoroState
    
    public init(state: PomodoroState = .stopped) {
        self.state   = state
    }
    
    public func start() -> Pomodoro {
        return Pomodoro(state: .running)
    }
    
    public func stop() -> Pomodoro {
        return Pomodoro(state: .stopped)
    }
        
    public func finish() -> Pomodoro {
        return Pomodoro(state: .finished)
    }
    
    public func isRunning() -> Bool {
        return state == .running
    }
    
    public func isNotRuning() -> Bool {
        return !isRunning()
    }
}
