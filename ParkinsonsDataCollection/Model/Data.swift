//
//  Data.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/18/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import Foundation

protocol RatedTest {
    var rating: Int { get set }
    var rater: String { get set }
    var variant: String { get set }
    var duration: Int { get set }
    var notes: String { get set }
}

// structs conform to Codable for easy JSON processing

struct MotionTaskData: Codable {
    var date: Date
    var userAccelerationX: Double
    var userAccelerationY: Double
    var userAccelerationZ: Double
    var roll: Double
    var pitch: Double
    var yaw: Double
}

struct FingerTapData: Codable {
    var date: Date
    var value: Int
}

// for these two tests, we can have each struct extend Identifiable as well, providing @DocumentID so Firestore can map each test to its id
struct MotionTest: RatedTest, Codable {
    var duration: Int
    var variant: String
    var rating: Int
    var rater: String
    var data: [MotionTaskData]
    var notes: String = ""
}

struct FingerTapTest: RatedTest, Codable {
    var duration: Int
    var variant: String
    var rating: Int
    var rater: String
    var data: [FingerTapData]
    var notes: String = ""
}


