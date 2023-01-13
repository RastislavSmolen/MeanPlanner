//
//  SimpleTests.swift
//  SimpleTests
//
//  Created by Rastislav Smolen on 06/08/2022.
//

import XCTest
@testable import Simple

class LevelUpTests: XCTestCase {
    
    let levelUp = LevelUp()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testIfIsReadyToLevelUpFalse(){
        let isReady = levelUp.isReadyToLevelUp(maxProgress: 100, currentProgress: 95)
        XCTAssertEqual(isReady, false)
    }
    func testIfIsReadyToLevelUpFalse2(){
        let isReady = levelUp.isReadyToLevelUp(maxProgress: 100, currentProgress: -100)
        XCTAssertEqual(isReady, false)
    }
    func testIfIsReadyToLevelUpTrue(){
        let isReady = levelUp.isReadyToLevelUp(maxProgress: 100, currentProgress: 110)
        XCTAssertEqual(isReady, true)
    }
    func testIfIsReadyToLevelUpTrue2(){
        let isReady = levelUp.isReadyToLevelUp(maxProgress: 100, currentProgress: 100)
        XCTAssertEqual(isReady, true)
    }
    func testisBelowZeroFalse(){
        let isBelowZero = levelUp.isBelowZero(currentXP: 100, maxXP: 100)
        XCTAssertEqual(isBelowZero, false)
    }
    func testisBelowZeroTrue(){
        let isBelowZero = levelUp.isBelowZero(currentXP: 100, maxXP: 90)
        XCTAssertEqual(isBelowZero, true)
    }
    func testCalculateNewExperienceEqual(){
        let proggress = levelUp.calculateNewXP(currentXP: 150, maxXP: 100)
        XCTAssertEqual(proggress, 50)
    }
    func testCalculateNewExperienceFailNotEqual(){
        let proggress = levelUp.calculateNewXP(currentXP: 150, maxXP: 100)
        XCTAssertNotEqual(proggress, 25)
    }
    func testCalculateMaxProgressEqual(){
        let maxProggress = levelUp.calculateMaxXP(maxXP: 100)
        XCTAssertEqual(maxProggress, 120)
    }
    func testCalculateMaxProggressNotEqual(){
        let maxProggress = levelUp.calculateMaxXP(maxXP: 100)
        XCTAssertNotEqual(maxProggress, 100)
    }
    func testLevelUpEqual(){
        let level = levelUp.levelUp(currentLevel: 1)
        XCTAssertEqual(level, 2)
    }
    func testLevelUpNotEqual(){
        let level = levelUp.levelUp(currentLevel: 1)
        XCTAssertNotEqual(level, 3)
    }
}
