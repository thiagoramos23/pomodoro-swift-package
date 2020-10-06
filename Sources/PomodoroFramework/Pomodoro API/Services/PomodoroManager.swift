//
//  File.swift
//  
//
//  Created by Thiago Ramos on 09/08/20.
//

import Foundation

protocol Manager {
    typealias CompletionHandler = (PomodoroType) -> Void
    typealias ReceivingValueHandler = (TimeInterval) -> Void

    func start(completion: @escaping CompletionHandler, receivingValue: @escaping ReceivingValueHandler)
    func pause()
    func reset()
}

public final class PomodoroManager: Manager {
    private var pomodoroTimer: CountdownTimer
    private var pomodoro: Pomodoro = Pomodoro(state: .stopped)
    private var nextPomodoroType: PomodoroType
    
    init(pomodoroTimer: CountdownTimer, nextPomodoroType: PomodoroType) {
        self.pomodoroTimer    = pomodoroTimer
        self.nextPomodoroType = nextPomodoroType
    }
    
    func pause() {
        guard self.pomodoro.isRunning() else { return }
        self.pomodoro = self.pomodoro.stop()
        self.pomodoroTimer.stop()
    }
    
    func reset() {
        guard self.pomodoro.isRunning() else { return }
        self.pomodoro = self.pomodoro.stop()
        self.pomodoroTimer.reset()
    }
        
    func start(completion: @escaping CompletionHandler, receivingValue: @escaping ReceivingValueHandler) {
        guard self.pomodoro.isNotRuning() else { return }
        
        self.pomodoro = self.pomodoro.start()
        self.pomodoroTimer.countdown { timeInterval in
            if timeInterval == 0 {
                completion(self.nextPomodoroType)
                self.reset()
            } else {
                receivingValue(timeInterval)
            }
        }
    }
    
}
