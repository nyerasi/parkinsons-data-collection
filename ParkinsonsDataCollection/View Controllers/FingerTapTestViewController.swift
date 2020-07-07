//
//  FingerTapTestViewController.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/5/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import UIKit

protocol TaskDelegate {
    // experimenting with protocols for future refactoring
    func configureTaskDetails()
    func startTask()
    func endTask()
    func updateViewModel()
}

class FingerTapTestViewController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var taskNumberOuterView: UIView!
    @IBOutlet var taskNumberLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var targetView: UIView!
    
    var viewModel: TaskViewModel?
    
    var targetIsEnabled: Bool = false
    var count: Int = 10
    var timer = Timer()
    var buttonTaps = [Int: Int]()
    
    // to log timestamps of each target's taps
    var targetTaps = [Int: [Date]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTaskDetails()
        disableTarget()
        // Do any additional setup after loading the view.
    }
    
    func enableTarget() {
        // disable/enable target and set colors
        for i in 0..<targetView.subviews.count {
            // retain cycle?
            UIView.animate(withDuration: 0.5) {
                self.targetView.subviews[i].backgroundColor = targetEnabledColors[i]
            }
            targetView.subviews[i].isUserInteractionEnabled = true
        }
    }
    
    func disableTarget() {
        // disable/enable target and set colors
        for i in 0..<targetView.subviews.count {
            UIView.animate(withDuration: 0.5) {
                self.targetView.subviews[i].backgroundColor = targetDisabledColors[i]
            }
            targetView.subviews[i].isUserInteractionEnabled = false
        }
    }
    
    func configureTaskDetails() {
        if let viewModel = viewModel {
            taskNumberLabel.text = "\(viewModel.taskNumber)"
            count = viewModel.taskDuration
        }
        taskNumberLabel.textColor = lightBlueColor
        taskNumberOuterView.layer.cornerRadius = 30
        taskNumberOuterView.layer.masksToBounds = true
        taskNumberOuterView.layer.borderWidth = 3
        taskNumberOuterView.layer.borderColor = lightBlueColor.cgColor
    }
    
    @IBAction func targetTapped(_ sender: UIButton) {
        // buttonTaps [button tag (1 - 5): number of taps]
        // log timestamps of taps as well!
        
        // testing UIButton animations — shorten to one iteration
        sender.flash()
        
        let currentValue = buttonTaps[sender.tag] ?? 0
        buttonTaps[sender.tag] = currentValue + 1
    }
    
    func presentCompletedAlert() {
        // calculate score and accuracy
        let message = "Great work! You scored \(calculateTotalScore()) points with an accuracy of \(calculateTotalAccuracy())."
        let alertController = UIAlertController(title: "Task Completed", message:
            message, preferredStyle: .alert)
        let rateAction = UIAlertAction(title: "Rate this task", style: .default) { (action) in
            // segue to rating screen
        }
        alertController.addAction(rateAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func calculateTotalScore() -> Int {
        // returns weighted sum of all taps
        var score = 0
        for entry in buttonTaps {
            score += entry.key * entry.value
        }
        return score
    }
    
    func calculateTotalAccuracy() -> String {
        // returns string describing % of taps that were highest value
        var totalTaps = 0
        for entry in buttonTaps {
            totalTaps += entry.value
        }
       let totalAccuracy = Double(buttonTaps[5] ?? 0) / Double(totalTaps)
        return "\(totalAccuracy * 100)%"
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        // create stopwatch timer
        if let viewModel = viewModel {
            self.count = viewModel.taskDuration
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateStopwatch()
        })
        
        // testing
        enableTarget()
    }
    
    @objc private func updateStopwatch() {
        count -= 1
        if count <= 0 {
            timer.invalidate()
            timeLabel.text = "00:00"
            
            // present alert, disable target
            presentCompletedAlert()
            disableTarget()
        } else {
            timeLabel.text = "00:0\(count)"
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
    
}
