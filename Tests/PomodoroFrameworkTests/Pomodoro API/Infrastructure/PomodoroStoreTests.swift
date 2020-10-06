//
//  File.swift
//  
//
//  Created by Thiago Ramos on 05/10/20.
//

import XCTest
@testable import PomodoroFramework

class PomodoroStoreTests: XCTestCase {
    
    func test_savePomodoro_shouldCreatePomodoroIdAndPomodoroTypeCorrectlySet() {
    }
}

class PomodoroLocalStoreMock: PomodoroStore {
    private var pomodoros: [PomodoroModel] = []
    
    func save(pomodoro: PomodoroModel) {
        pomodoros.append(pomodoro)
    }
    
    func getTotalCompleted() -> Int {
        return pomodoros.count
    }
}

struct LocalPomodoroModel: PomodoroModel {
    var id: UUID
    var type: PomodoroModelType = .workInterval
}
