//
//  CounterTests.swift
//  MyPomodoroTests
//
//  Created by Thiago Ramos on 24/08/20.
//

import XCTest
@testable import PomodoroFramework

class CounterTests: XCTestCase {
    
    func test_resume_shouldCallDispatchHandler() {
        let sut = makeSut()
        let exp = expectation(description: "Dispatch handler was called")
        exp.expectedFulfillmentCount = 1
        
        sut.dispatchEventHandler = {
            exp.fulfill()
        }
        sut.resume()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_suspend_shouldNotLetCallDispatchHandler() {
        let sut = makeSut()
        let exp = expectation(description: "Dispatch handler was called")
        exp.isInverted = true
        
        sut.resume()
        sut.suspend()
        sut.dispatchEventHandler = {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_deallocation_shouldSetDispatchHandlerToNil() {
        var sut: Counter? = makeSut()
        let exp = expectation(description: "Dispatch handler was called")
        sut?.dispatchEventHandler = {
            exp.fulfill()
        }
        sut?.resume()
        
        wait(for: [exp], timeout: 1.0)
        
        sut = nil
        
        XCTAssertNil(sut?.dispatchEventHandler)
    }
    
    private func makeSut() -> Counter {
        let sut: Counter = Counter(interval: TimeInterval(1))
        verifyMemoryLeak(sut)
        return sut
    }
    
    private func verifyMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Should have dealocated after test", file: file, line: line)
        }
    }

 }
