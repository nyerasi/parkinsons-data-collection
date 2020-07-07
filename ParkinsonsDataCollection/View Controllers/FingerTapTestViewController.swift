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
        print("tapped target with score \(sender.tag)")
        let currentValue = buttonTaps[sender.tag] ?? 0
        buttonTaps[sender.tag] = currentValue + 1
    }
    
    func presentCompletedAlert() {
        let alertController = UIAlertController(title: "Task Completed", message:
            "The time has elapsed for this task!", preferredStyle: .alert)
        let rateAction = UIAlertAction(title: "Rate this task", style: .default) { (action) in
            // segue to rating screen
        }
        alertController.addAction(rateAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        // create stopwatch timer
        
        self.timer = Timer(timeInterval: 1, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
        print("created timer")
        
        // testing
        enableTarget()
    }
    
    @objc private func updateStopwatch() {
        print("updating timer")
        count -= 1
        if count  <= 0 {
//            if var timer = timer
            timer.invalidate()
            timeLabel.text = "00:00"
            
            // alert time has elapsed
            presentCompletedAlert()
            
            
            // disable button and segue
        } else {
            timeLabel.text = "00:\(count & 60)"
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
