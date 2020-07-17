//
//  TaskViewModel.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/4/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import Foundation

// GOAL: replace all this mess with the objects in Task.swift (eventually)

// initialize with default parameters
class TaskViewModel {
    var task: MovementTask = .pronationSupination
    var taskNumber: Int = 1
    var taskName: String = "Pronation-Supination"
    var taskInstructions: String = "Alternate between pronation and supination of the hand"
    var taskGoal: String = "Perform the task as quickly and try to maintain full range-of-motion!"
    var taskDuration: Int = 10
    var leftSideDone: Bool = false
    var rightSideDone: Bool = false
    
    var state: TaskState = .start
    
    func updateTask() {
        if leftSideDone && rightSideDone && taskDuration == 10 {
            taskDuration = 20
            leftSideDone = false
            rightSideDone = false
            
            return
        }
        switch task {
        case .pronationSupination:
            if leftSideDone && rightSideDone && taskDuration == 20 {
                
                // update to finger tap (one target)!
                task = .fingerTapOne
                taskNumber = 2
                taskName = "Finger Tap: One Target"
                taskInstructions = "Tap the middle of the target as many times as possible"
                taskGoal = "Perform the task as quickly  as possible and try to maintain accuracy!"
                taskDuration = 10
                
                leftSideDone = false
                rightSideDone = false
                
                return
            }
        case .fingerTapOne:
            if leftSideDone && rightSideDone && taskDuration == 20 {
                
                // update to finger tap (two target)!
                task = .fingerTapTwo
                taskNumber = 3
                taskName = "Finger Tap: Two Targets"
                taskInstructions = "Tap between the target and a marked spot 30 centimeters away"
                taskGoal = "Perform the task as quickly as possible and try to maintain accuracy!"
                taskDuration = 10
                
                leftSideDone = false
                rightSideDone = false
                
                return
            }
        case .fingerTapTwo:
            // done with all three tests!
            task = .questionnaire
            taskNumber = 4
            
            taskName = "Symptom Questionnaire"
            taskInstructions = "Mark which of the following best applies to your current state"
            taskGoal = "Ask your clinician for more information!"
            taskDuration = 20
            // other attributes (left/right done) not relevant to this
            return
        default:
            return
        }
    }
}

// singleton — shared instance of view model
var viewModel = TaskViewModel()
