//
//  TaskViewModel.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/4/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import Foundation

struct TaskViewModel {
    var taskNumber: Int
    var taskName: String
    var taskInstructions: String
    var taskGoal: String
    var taskDuration: Int = 10
    var leftSideDone: Bool = false
    var rightSideDone: Bool = false
}

var ExampleTestModel = TaskViewModel(taskNumber: 1, taskName: "Pronation-Supination", taskInstructions: "Alternate between pronation and supination of the hand", taskGoal: "Perform the task as quickly and try to maintain full range-of-motion!", leftSideDone: true, rightSideDone: false)
