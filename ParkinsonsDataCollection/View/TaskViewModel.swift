//
//  TaskViewModel.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/4/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import Foundation

// modify to class (avoid retain cycles?)
struct TaskViewModel {
    var task: MovementTask
    var taskNumber: Int
    var taskName: String
    var taskInstructions: String
    var taskGoal: String
    var taskDuration: Int = 10
    var leftSideDone: Bool = false
    var rightSideDone: Bool = false
}

var PronationTestModel = TaskViewModel(task: .pronationSupination, taskNumber: 1, taskName: "Pronation-Supination", taskInstructions: "Alternate between pronation and supination of the hand", taskGoal: "Perform the task as quickly and try to maintain full range-of-motion!", leftSideDone: true, rightSideDone: false)

var FingerTapTestModel = TaskViewModel(task: .fingerTapOne, taskNumber: 2, taskName: "Finger Tap: One Target", taskInstructions: "Tap the middle of the target as many times as possible", taskGoal: "Perform the task as quickly and try to maintain accuracy!", leftSideDone: false, rightSideDone: false)
