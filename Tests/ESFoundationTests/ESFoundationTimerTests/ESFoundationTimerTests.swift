//
//  File.swift
//  
//
//  Created by 罗树新 on 2020/12/25.
//

import Foundation

import XCTest
@testable import ESTimer

final class ESFoundationTimerTests: XCTestCase {
    func testForRepeat() {
        var count = 0;
        let promise = expectation(description: "Just wait request")

        let timer = Timer(1, repeats: true) {
            count += 1
            print("testForRepeat \(count)")
            if count == 50 {
                promise.fulfill()
            }
        }
        timer.start()
        waitForExpectations(timeout: 60) { (error) in
        }
    }
    
    func testForUnRepeat() {
        
        let promise = expectation(description: "Just wait request")
        var count = 0;
        let timer = Timer(1) {
            count += 1
            print("testForUnRepeat \(count)")
            promise.fulfill()
        }
        timer.start()
        waitForExpectations(timeout: 60) { (error) in
        }
    }
    
    
    
    static var allTests = [
        ("testForRepeat", testForRepeat),
        ("testForUnRepeat", testForUnRepeat)
    ]
    
}
