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

// GOAL: use these abtractions to clean up the app's navigation and write unit tests

// for use in navigation
enum MovementTask: String {
    case pronationSupination = "Pronation-Supination"
    case fingerTapOne = "Finger Tap: One Target"
    case fingerTapTwo = "Finger Tap: Two Targets"
    case questionnaire = "Symptom Questionnaire"
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

enum CurrentState {
    case start
    case firstDurationLeftSide
    case firstDurationRightSide
    case secondDurationLeftSide
    case secondDurationRightSide
    case rating
}

/*
 case notStarted
 case leftSideDone
 case rightSideDone
 case bothSidesDone
 case isRated
 */

enum TaskState {
    case start
    case left
    case right
    case done
}

enum ExamState {
    case notStarted
    case leftSideDone
    case rightSideDone
    case bothSidesDone
    case isRated
}

class Task {
    var task: MovementTask
    var information: TaskInformation
    var state: TaskState
    
    init() {
        self.task = .pronationSupination
        self.information = TaskInformation(taskName: "Supination-Pronation", taskNumber: 1, taskInstructions: "Alternate between pronation and supination of the hand", taskGoal: "Perform the task as quickly and try to maintain full range-of-motion!", taskDuration: 10)
        self.state = .start
        
    }
    
    init(task: MovementTask, information: TaskInformation, state: TaskState) {
        self.task = task
        self.information = information
        self.state = state
    }
}

// shared object for managing state
var task = Task()
