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

class TaskOverviewViewController: UIViewController {
    
    @IBOutlet var taskNumberLabel: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskInstructionsLabel: UILabel!
    @IBOutlet var taskGoalLabel: UILabel!
    @IBOutlet var taskNumberOuterView: UIView!
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet var rightSideOuterView: UIView!
    @IBOutlet var leftSideOuterView: UIView!
    @IBOutlet var rightSideStartButton: UIButton!
    @IBOutlet var leftSideStartButton: UIButton!
    
    var viewModel: TaskViewModel? = PronationTestModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskDetails()
        configureButtons()
        updateButtons()
        // Do any additional setup after loading the view.
    }
    
    // prevent other view controllers from rotating UI — info.plist
    
    @IBAction func startRightSide(_ sender: Any) {
        if let viewModel = viewModel {
            switch viewModel.task {
            case .pronationSupination:
                self.performSegue(withIdentifier: "toSupinationPronationTask", sender: self)
            case .fingerTapOne:
                self.performSegue(withIdentifier: "toFingerTapTask", sender: self)
            case .fingerTapTwo:
                self.performSegue(withIdentifier: "toFingerTapTask", sender: self)
            }
        }
    }
    
    @IBAction func startLeftSide(_ sender: Any) {
        if let viewModel = viewModel {
            switch viewModel.task {
            case .pronationSupination:
                self.performSegue(withIdentifier: "toSupinationPronationTask", sender: self)
            case .fingerTapOne:
                // update subtitle using view model
                self.performSegue(withIdentifier: "toFingerTapTask", sender: self)
            case .fingerTapTwo:
                // update subtitle
                self.performSegue(withIdentifier: "toFingerTapTask", sender: self)
            }
        }
    }
    
    private func configureTaskDetails() {
        if let viewModel = viewModel {
            taskNumberLabel.text = "\(viewModel.taskNumber)"
            taskNameLabel.text = viewModel.taskName
            taskInstructionsLabel.text = viewModel.taskInstructions
            taskGoalLabel.text = viewModel.taskInstructions
        }
        
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
        if let viewModel = viewModel {
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
                rightSideStartButton.layer.borderWidth = 0
                
                rightSideStartButton.setTitle("START", for: .normal)
                rightSideStartButton.setTitleColor(.black, for: .normal)
                
                rightSideStartButton.isEnabled = true
            }
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
        if let viewModel = viewModel {
            // segue to appropriate task
            if let dest = segue.destination as? FingerTapTestViewController {
                dest.viewModel = self.viewModel
            } else if let dest = segue.destination as? RotationTestViewController {
                dest.viewModel = self.viewModel
            }
        }
    }
    
}
