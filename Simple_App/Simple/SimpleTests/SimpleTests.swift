//
//  SimpleTests.swift
//  SimpleTests
//
//  Created by Rastislav Smolen on 06/08/2022.
//

import XCTest
@testable import Simple

class SimpleTests: XCTestCase {

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
        let levelUp = LevelUp()
        let isReady = levelUp.isReadyToLevelUp(maxProgress: 100, currentProgress: 95)
        XCTAssertEqual(isReady, false)
    }
    
    func testIfIsReadyToLevelUpFalse2(){
        let levelUp = LevelUp()
        let isReady = levelUp.isReadyToLevelUp(maxProgress: 100, currentProgress: -100)
        XCTAssertEqual(isReady, false)

    }
    func testIfIsReadyToLevelUpTrue(){
        let levelUp = LevelUp()
        let isReady = levelUp.isReadyToLevelUp(maxProgress: 100, currentProgress: 110)
        XCTAssertEqual(isReady, true)

    }
    
    func testIfIsReadyToLevelUpTrue2(){
        let levelUp = LevelUp()
        let isReady = levelUp.isReadyToLevelUp(maxProgress: 100, currentProgress: 100)
        XCTAssertEqual(isReady, true)

    }
    
    func testisBelowZeroFalse(){
        let levelUp = LevelUp()
        let isBelowZero = levelUp.isBelowZero(currentExperience: 100, maxExperience: 100)
        XCTAssertEqual(isBelowZero, false)

        
    }
    func testisBelowZeroTrue(){
        let levelUp = LevelUp()
        let isBelowZero = levelUp.isBelowZero(currentExperience: 100, maxExperience: 90)
        XCTAssertEqual(isBelowZero, true)

    }
    func testCalculateNewExperienceEqual(){
        let levelUp = LevelUp()
        let proggress = levelUp.calculateNewExperience(currentExperience: 150, maxExperience: 100)
        XCTAssertEqual(proggress, 50)
    }
    func testCalculateNewExperienceFailNotEqual(){
        let levelUp = LevelUp()
        let proggress = levelUp.calculateNewExperience(currentExperience: 150, maxExperience: 100)
        XCTAssertNotEqual(proggress, 25)
    }
}
