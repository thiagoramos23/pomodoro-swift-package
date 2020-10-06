//
//  UnpausePomodoroUseCaseTests.swift
//  MyPomodoroTests
//
//  Created by Thiago Ramos on 29/08/20.
//
import XCTest
@testable import PomodoroFramework

class UnpausePomodoroUseCaseTests: XCTestCase {
        
    func test_unpausePomodoro_shouldRestartPomodoroFromWhereItStopped() {
        let (sut, timerSpy) = makeSut(seconds: 5)
        let exp = expectation(description: "Call receiving value one time")
        sut.start { _ in
        } receivingValue: { _ in
            sut.pause()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        sut.start(completion: {_ in}, receivingValue: {_ in})
        XCTAssertEqual(timerSpy.stopCallCount, 1)
        XCTAssertEqual(timerSpy.completionCallCount, 5)
    }
    
    func test_unpausePomodoro_whenPomodoroIsRunning_shouldDoNothing() {
        let (sut, timerSpy) = makeSut(seconds: 5)
        let exp = expectation(description: "Call receiving value 4 times")
        exp.expectedFulfillmentCount = 4
        
        sut.start { _ in
        } receivingValue: { _ in
            exp.fulfill()
            sut.start(completion: {_ in}, receivingValue: {_ in})
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(timerSpy.completionCallCount, 5)
    }
    
    // MARK: - Helpers
    func makeSut(seconds: TimeInterval) -> (Manager, PomodoroTimerSpy) {
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
