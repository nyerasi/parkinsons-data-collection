//
//  Data.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/18/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import Foundation

protocol RatedTest {
    var rating: Int { get }
    var rater: String { get }
    var variant: String { get }
    var side: String { get }
    var duration: Int { get }
    var notes: String { get }
}

// structs conform to Codable for easy JSON processing
struct MotionTaskData: Codable {
    let date: Date
    let gravityX: Double
    let gravityY: Double
    let gravityZ: Double
    let userAccelerationX: Double
    let userAccelerationY: Double
    let userAccelerationZ: Double
    let roll: Double
    let pitch: Double
    let yaw: Double
}

struct FingerTapData: Codable {
    let date: Date
    let value: Int
}

// for these two tests, we can have each struct extend Identifiable as well, providing @DocumentID so Firestore can map each test to its id
struct MotionTest: RatedTest, Codable {
    let side: String
    let duration: Int
    let variant: String
    let rating: Int
    let rater: String
    let data: [MotionTaskData]
    var notes: String = ""
}

struct FingerTapTest: RatedTest, Codable {
    let side: String
    let duration: Int
    let variant: String
    let rating: Int
    let rater: String
    let data: [FingerTapData]
    var notes: String = ""
}


