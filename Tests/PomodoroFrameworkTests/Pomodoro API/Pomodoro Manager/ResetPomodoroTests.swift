//
//  StopPomodoroUseCaseTests.swift
//  MyPomodoroTests
//
//  Created by Thiago Ramos on 30/08/20.
//

import XCTest
@testable import PomodoroFramework

final class ResetPomodoroUseCaseTests: XCTestCase {
    
    func test_resetPomodoro_shouldCallResetOnTimer() {
        let (sut, timerSpy) = makeSut(seconds: 5)
        let exp = expectation(description: "When pomodoro is counting down")
        exp.expectedFulfillmentCount = 1
        
        sut.start { _ in
        } receivingValue: { _ in
            exp.fulfill()
            sut.reset()
        }
                
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(timerSpy.resetCallCount, 1)
    }
    
    func test_resetPomodoro_whenPomodoroIsAlreadyStopped_doNothing() {
        let (sut, timerSpy) = makeSut(seconds: 5)

        sut.reset()
        
        XCTAssertEqual(timerSpy.resetCallCount, 0)
    }
        
    // MARK: - Helpers
    func makeSut(seconds: TimeInterval) -> (PomodoroManager, PomodoroTimerSpy) {
        let timerSpy        = PomodoroTimerSpy(seconds: seconds)
        let pomodoroManager = PomodoroManager(pomodoroTimer: timerSpy, nextPomodoroType: PomodoroType.breakInterval)
        verifyMemoryLeak(pomodoroManager)
        return (pomodoroManager, timerSpy)
    }
    
    private func verifyMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Should have dealocated after test", file: file, line: line)
        }
    }

}
