//
//  QuestionnaireViewController.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/17/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import UIKit

class QuestionnaireViewController: UIViewController {

    @IBOutlet var taskNumberOuterView: UIView!
    @IBOutlet var taskNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskDetails()
        
        navigationItem.hidesBackButton = true
    }
    
    private func configureTaskDetails() {
        taskNumberLabel.text = "\(viewModel.taskNumber)"
//        taskNameLabel.text = viewModel.taskName
//        taskSubtitleLabel.text = "\(viewModel.taskDuration) seconds each side"
//        taskInstructionsLabel.text = viewModel.taskInstructions
//        taskGoalLabel.text = viewModel.taskGoal
        
        taskNumberLabel.textColor = lightBlueColor
        taskNumberOuterView.backgroundColor = .clear
        taskNumberOuterView.layer.cornerRadius = 30
        taskNumberOuterView.layer.masksToBounds = true
        taskNumberOuterView.layer.borderWidth = 3
        taskNumberOuterView.layer.borderColor = lightBlueColor.cgColor
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
