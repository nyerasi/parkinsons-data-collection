//
//  TaskOverviewViewController.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/4/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import UIKit

protocol TaskOverviewDelegate {
    // for future additions, code readability
    
    func configureButtons()
    func navigateToTask()
}

class OverviewViewController: UIViewController {
    
    @IBOutlet var taskNumberLabel: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskSubtitleLabel: UILabel!
    @IBOutlet var taskInstructionsLabel: UILabel!
    @IBOutlet var taskGoalLabel: UILabel!
    @IBOutlet var taskNumberOuterView: UIView!
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet var rightSideOuterView: UIView!
    @IBOutlet var leftSideOuterView: UIView!
    @IBOutlet var rightSideStartButton: UIButton!
    @IBOutlet var leftSideStartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskDetails()
        configureButtons()
        updateButtons()

        navigationItem.hidesBackButton = true
    }
    
    // prevent other view controllers from rotating UI — info.plist
    
    @IBAction func startRightSide(_ sender: Any) {
        viewModel.state = .right
        
        switch viewModel.task {
        case .pronationSupination:
            self.performSegue(withIdentifier: "toSupinationPronationTask", sender: self)
        case .fingerTapOne:
            self.performSegue(withIdentifier: "toFingerTapTask", sender: self)
        case .fingerTapTwo:
            self.performSegue(withIdentifier: "toFingerTapTask", sender: self)
        default:
            return
        }
    }
    
    @IBAction func startLeftSide(_ sender: Any) {
        viewModel.state = .left
        
        switch viewModel.task {
        case .pronationSupination:
            self.performSegue(withIdentifier: "toSupinationPronationTask", sender: self)
        case .fingerTapOne:
            // update subtitle using view model
            self.performSegue(withIdentifier: "toFingerTapTask", sender: self)
        case .fingerTapTwo:
            // update subtitle
            self.performSegue(withIdentifier: "toFingerTapTask", sender: self)
        default:
            return
        }
    }
    
    private func configureTaskDetails() {
        taskNumberLabel.text = "\(viewModel.taskNumber)"
        taskNameLabel.text = viewModel.taskName
        taskSubtitleLabel.text = "\(viewModel.taskDuration) seconds each side"
        taskInstructionsLabel.text = viewModel.taskInstructions
        taskGoalLabel.text = viewModel.taskGoal
        
        taskNumberLabel.textColor = lightBlueColor
        taskNumberOuterView.backgroundColor = .clear
        taskNumberOuterView.layer.cornerRadius = 30
        taskNumberOuterView.layer.masksToBounds = true
        taskNumberOuterView.layer.borderWidth = 3
        taskNumberOuterView.layer.borderColor = lightBlueColor.cgColor
        
    }
    
    private func configureButtons() {
        rightSideOuterView.layer.masksToBounds = true
        rightSideOuterView.layer.cornerRadius = 10
        
        leftSideOuterView.layer.masksToBounds = true
        leftSideOuterView.layer.cornerRadius = 10
        
        rightSideStartButton.layer.masksToBounds = true
        rightSideStartButton.layer.cornerRadius = 10
        
        leftSideStartButton.layer.masksToBounds = true
        leftSideStartButton.layer.cornerRadius = 10
    }
    
    private func updateButtons() {
        if viewModel.leftSideDone {
            leftSideOuterView.backgroundColor = lightBlueColor
            leftSideStartButton.layer.borderWidth = 2
            leftSideStartButton.layer.borderColor = UIColor.white.cgColor
            
            // set button state
            leftSideStartButton.setTitle("DONE", for: .normal)
            leftSideStartButton.setTitleColor(.white, for: .normal)
            leftSideStartButton.backgroundColor = lightBlueColor
            // disable
            leftSideStartButton.isEnabled = false
        } else {
            leftSideOuterView.backgroundColor = darkBlueColor
            leftSideStartButton.backgroundColor = .white
            leftSideStartButton.layer.borderWidth = 0
            leftSideStartButton.setTitle("START", for: .normal)
            leftSideStartButton.setTitleColor(.black, for: .normal)
            leftSideStartButton.isEnabled = true
        }
        if viewModel.rightSideDone {
            rightSideOuterView.backgroundColor = lightBlueColor
            rightSideStartButton.layer.borderWidth = 2
            rightSideStartButton.layer.borderColor = UIColor.white.cgColor
            
            rightSideStartButton.setTitle("DONE", for: .normal)
            rightSideStartButton.setTitleColor(.white, for: .normal)
            rightSideStartButton.backgroundColor = lightBlueColor
            rightSideStartButton.isEnabled = false
        } else {
            rightSideOuterView.backgroundColor = darkBlueColor
            rightSideStartButton.backgroundColor = .white
            rightSideStartButton.layer.borderWidth = 0
            
            rightSideStartButton.setTitle("START", for: .normal)
            rightSideStartButton.setTitleColor(.black, for: .normal)
            
            rightSideStartButton.isEnabled = true
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue to appropriate task
        if let dest = segue.destination as? FingerTapTestViewController {
        } else if let dest = segue.destination as? RotationTestViewController {
        }
    }
    
    @IBAction func unwindFromRest( _ seg: UIStoryboardSegue) {
        
        // from rest view controller after rating
        /*
         possible scenarios for a task are:
         1. you completed first side of task with first duration
         2. you completed second side of task with first duration
         3. you completed first side of task with second duration
         4. you completed second side of task with second duration
         */
        configureTaskDetails()
        updateButtons()
    }
    
}
