//
//  File.swift
//  
//
//  Created by Thiago Ramos on 04/08/20.
//

import XCTest
@testable import PomodoroFramework

final class StartPomodoroUseCaseTests: XCTestCase {
    
    func test_startPomodoro_shouldStartCounterAndReceiveValuesForTheSpecifiedAmountOfSeconds() {
        let (sut, timerSpy, exp) = makeSut(seconds: 5, fulfillmentExpectationCount: 4, expectationMessage: "When pomodoro is couting down")
        
        sut.start { _ in
        } receivingValue: { _ in
            exp.fulfill()
        }
        
        XCTAssertEqual(timerSpy.completionCallCount, 5)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_startPomodoro_whenPomodoroIsCountingDown_shouldcallCompletionWhenFinishes() {
        let (sut, timerSpy, exp) = makeSut(seconds: 5, fulfillmentExpectationCount: 1, expectationMessage: "When pomodoro finishes")
        
        sut.start { _ in
            exp.fulfill()
        } receivingValue: { _ in
        }
        
        XCTAssertEqual(timerSpy.completionCallCount, 5)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_startPomodoro_whileCountdownTimerIsRunning_shouldNotStartNewPomodoro() {
        let (sut, timerSpy, exp) = makeSut(seconds: 5, fulfillmentExpectationCount: 4, expectationMessage: "When pomodoro is not in running state")
        
        let sut2 = sut
        let exp2 = expectation(description: "should never be called")
        exp2.isInverted = true

        sut.start { _ in
        } receivingValue: { _ in
            exp.fulfill()
            sut2.start { _ in
            } receivingValue: { _ in
                exp2.fulfill()
            }
        }
        
        XCTAssertEqual(timerSpy.completionCallCount, 5)
        wait(for: [exp2, exp], timeout: 1.0)
    }
        
    // MARK: - Helpers
    func makeSut(seconds: TimeInterval, fulfillmentExpectationCount: Int, expectationMessage: String = "When testing pomodoro") -> (PomodoroManager, PomodoroTimerSpy, XCTestExpectation) {
        let timerSpy        = PomodoroTimerSpy(seconds: seconds)
        let pomodoroManager = PomodoroManager(pomodoroTimer: timerSpy, nextPomodoroType: PomodoroType.breakInterval)
        let exp = expectation(description: expectationMessage)
        exp.expectedFulfillmentCount = fulfillmentExpectationCount
        verifyMemoryLeak(pomodoroManager)
        return (pomodoroManager, timerSpy, exp)
    }
    
    private func verifyMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Should have dealocated after test", file: file, line: line)
        }
    }

}
