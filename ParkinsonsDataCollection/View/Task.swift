//
//  Task.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/6/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import Foundation

/*
 Check out common Swift design patterns:
 https://rubygarage.org/blog/swift-design-patterns
 */

// for use in navigation
enum MovementTask: String {
    case pronationSupination = "Pronation-Supination"
    case fingerTapOne = "Finger Tap: One Target"
    case fingerTapTwo = "Finger Tap: Two Targets"
}

enum TaskState {
    case notStarted
    case leftSideDone
    case rightSideDone
    case bothSidesDone
    case isRated
}

struct TaskInformation {
    var taskName: String
    var taskNumber: Int
    var taskInstructions: String
    var taskGoal: String
    var taskDuration: Int
}

struct MotionTaskData {
    var date: Date
    var userAccelerationX: Double
    var userAccelerationY: Double
    var userAccelerationZ: Double
    var roll: Double
    var pitch: Double
    var yaw: Double
}

class Task {
    var task: MovementTask
    var information: TaskInformation
    var state: TaskState
    init(task: MovementTask, information: TaskInformation, state: TaskState) {
        self.task = task
        self.information = information
        self.state = state
    }
}
