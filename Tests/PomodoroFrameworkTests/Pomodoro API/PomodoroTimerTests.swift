//
//  PomodoroCounterTests.swift
//  MyPomodoroTests
//
//  Created by Thiago Ramos on 11/08/20.
//

import XCTest
@testable import PomodoroFramework

class PomodoroTimerTests: XCTestCase {

    func test_countdown_countDownsPomodoroUntilZero() {
        let (sut, _) = makeSut(seconds: 5)
        let exp = expectation(description: "Counting down pomodoro")
        exp.expectedFulfillmentCount = 5

        sut.countdown() { _ in
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
    
    func test_countdown_callsDispatchEventHandlerEveryTimeInterval() {
        let (sut, spy) = makeSut(seconds: 10)
        let exp = expectation(description: "Counting down pomodoro")
        exp.expectedFulfillmentCount = 10

        sut.countdown { _ in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(spy.dispatchCallCount, 10)
    }
    
    func test_stop_shouldSuspendCounter() {
        let (sut, spy) = makeSut(seconds: 10)
        let exp = expectation(description: "Should not keep calling countdown")
        exp.expectedFulfillmentCount = 1
        
        sut.countdown { [weak sut] time in
            sut?.stop()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(spy.stopCallCount, 1)
    }
    
    func test_reset_shouldMakeCounterResetToTheAmountOfSecondsBeforeStarted() {
        let (sut, spy) = makeSut(seconds: 10)
        sut.countdown { [weak sut] time in
            sut?.reset()
        }
        
        let exp = expectation(description: "When starting counting again after reset")
        exp.expectedFulfillmentCount = 10
        sut.countdown { timer in
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(spy.stopCallCount, 2)
        XCTAssertEqual(spy.dispatchCallCount, 11)
    }
    
    private func makeSut(seconds: Int) -> (PomodoroTimer, CounterSpy) {
        let spy = CounterSpy(interval: TimeInterval(1))
        let sut = PomodoroTimer(timeInSeconds: TimeInterval(seconds), counter: spy)
        verifyMemoryLeak(sut)
        return (sut, spy)
    }
    
    private func verifyMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Should have dealocated after test", file: file, line: line)
        }
    }

    
    class CounterSpy: InternalCounter {
        var isSuspended = false
        var dispatchCallCount = 0
        var stopCallCount = 0
        
        var dispatchEventHandler: (() -> Void)?
        
        private var interval: TimeInterval
        
        init(interval: TimeInterval) {
            self.interval = interval
        }
                        
        func resume() {
            self.isSuspended = false
            while !isSuspended {
                self.dispatchEventHandler?()
                self.dispatchCallCount += 1
            }
        }
        
        func suspend() {
            self.stopCallCount += 1
            self.isSuspended = true
        }
    }
}
