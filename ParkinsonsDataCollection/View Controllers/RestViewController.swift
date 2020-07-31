//
//  RestViewController.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/5/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import UIKit

class RestViewController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var taskNumberLabel: UILabel!
    @IBOutlet var taskNumberOuterView: UIView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    var count: Int = 30
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskDetails()
        configureButton()
        startStopwatch()
        
        doneButton.alpha = 0
        doneButton.isEnabled = false
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        updateTask()
        
        if viewModel.task == .questionnaire {
            performSegue(withIdentifier: "toQuestionnaire", sender: self)
        } else {
            performSegue(withIdentifier: "unwindToOverviewFromRest", sender: self)
        }
    }
    
    private func configureTaskDetails() {
        taskNumberLabel.text = "\(viewModel.taskNumber)"
        timeLabel.text = "00:\(count)"
        //            subtitleLabel.text = "\(viewModel.taskName)"
        taskNumberLabel.textColor = lightBlueColor
        taskNumberOuterView.backgroundColor = .clear
        taskNumberOuterView.layer.cornerRadius = 30
        taskNumberOuterView.layer.masksToBounds = true
        taskNumberOuterView.layer.borderWidth = 3
        taskNumberOuterView.layer.borderColor = lightBlueColor.cgColor
    }
    
    private func configureButton() {
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 10
    }
    
    func startStopwatch() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateStopwatch()
        })
    }
    
    @objc private func updateStopwatch() {
        count -= 1
        // format counter for label
        if count <= 0 {
            timer.invalidate()
            timeLabel.text = "00:00"
            
            // enable segue to task overview/other side
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.doneButton.alpha = 1
            }
            doneButton.isEnabled = true
        } else if count < 10 {
            timeLabel.text = "00:0\(count)"
        } else {
            timeLabel.text = "00:\(count)"
        }
    }
    
    func updateTask() {
        // marks the respective side as done and checks to see if the task should be updated by modifying the view model
        switch viewModel.state {
        case .left:
            viewModel.leftSideDone = true
        case .right:
            viewModel.rightSideDone = true
        default:
            break
        }
        
        viewModel.updateTask()
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
