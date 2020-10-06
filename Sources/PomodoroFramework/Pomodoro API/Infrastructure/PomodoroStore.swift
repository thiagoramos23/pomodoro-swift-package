//
//  File.swift
//  
//
//  Created by Thiago Ramos on 05/10/20.
//

import Foundation

enum PomodoroModelType {
    case workInterval
    case breakInterval
}

protocol PomodoroModel {
    var id: UUID { get set }
    var type: PomodoroModelType { get set }
}

protocol PomodoroStore {
    
    func save(pomodoro: PomodoroModel)
    func getTotalCompleted() -> Int
}
