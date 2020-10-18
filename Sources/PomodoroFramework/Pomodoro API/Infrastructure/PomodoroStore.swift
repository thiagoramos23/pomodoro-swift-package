//
//  File.swift
//  
//
//  Created by Thiago Ramos on 05/10/20.
//

import Foundation

public enum PomodoroModelType {
    case workInterval
    case breakInterval
}

public protocol PomodoroModel {
    var id: UUID { get set }
    var type: PomodoroModelType { get set }
}

public protocol PomodoroStore {
    
    func save(pomodoro: PomodoroModel)
    func getTotalCompleted() -> Int
}
