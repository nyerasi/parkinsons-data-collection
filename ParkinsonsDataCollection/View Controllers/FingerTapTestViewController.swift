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
    // requires a timer?
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
    @IBOutlet var startButton: UIButton!
    
    var targetIsEnabled: Bool = false
    var count: Int = 10
    var timer = Timer()
    var buttonTaps = [Int: Int]()
    
    // to log timestamps of each target's taps
    var targetTaps = [Int: [Date]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTaskDetails()
        configureButton()
        disableTarget()
    }
    
    func enableTarget() {
        // enable target and set colors
        for i in 0..<targetView.subviews.count {
            // retain cycle?
            UIView.animate(withDuration: 0.5) {
                self.targetView.subviews[i].backgroundColor = targetEnabledColors[i]
            }
            targetView.subviews[i].isUserInteractionEnabled = true
        }
    }
    
    func disableTarget() {
        // disable target and set colors
        for i in 0..<targetView.subviews.count {
            UIView.animate(withDuration: 0.5) {
                self.targetView.subviews[i].backgroundColor = targetDisabledColors[i]
            }
            targetView.subviews[i].isUserInteractionEnabled = false
        }
    }
    
    private func configureTaskDetails() {
        taskNumberLabel.text = "\(viewModel.taskNumber)"
        timeLabel.text = "00:\(viewModel.taskDuration)"
        taskNumberLabel.textColor = lightBlueColor
        taskNumberOuterView.backgroundColor = .clear
        taskNumberOuterView.layer.cornerRadius = 30
        taskNumberOuterView.layer.masksToBounds = true
        taskNumberOuterView.layer.borderWidth = 3
        taskNumberOuterView.layer.borderColor = lightBlueColor.cgColor
    }
    
    private func configureButton() {
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 10
    }
    
    @IBAction func targetTapped(_ sender: UIButton) {
        // buttonTaps [button tag (1 - 5): number of taps]
        let currentValue = buttonTaps[sender.tag] ?? 0
        buttonTaps[sender.tag] = currentValue + 1
        
        // testing UIButton animations — shorten to one iteration?
        // sender.flash()
        
        // log timestamps as well — what's going to make this easiest to process/analyze?
        let currentDate = Date()
        targetTaps[sender.tag]?.append(currentDate)
    }
    
    func presentCompletedAlert() {
        // calculate score and accuracy
        let message = "Great work! You scored \(calculateTotalScore()) points with an accuracy of \(calculateTotalAccuracy())."
        let alertController = UIAlertController(title: "Task Completed", message:
            message, preferredStyle: .alert)
        let rateAction = UIAlertAction(title: "Rate this task", style: .default) { [weak self] (action) in
            // segue to rating screen
            self?.performSegue(withIdentifier: "toRating", sender: self)
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
        startButton.isEnabled = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.startButton.alpha = 0
        }
        
        self.count = viewModel.taskDuration
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateStopwatch()
        })
        
        // add color, enable buttons in target
        enableTarget()
    }
    
    @objc private func updateStopwatch() {
        count -= 1
        // format counter for label
        if count <= 0 {
            timer.invalidate()
            timeLabel.text = "00:00"
            
            // present alert, disable target
            presentCompletedAlert()
            disableTarget()
        } else if count < 10 {
            timeLabel.text = "00:0\(count)"
        } else {
            timeLabel.text = "00:\(count)"
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
        // to rating, pass along view model!
        // segue to appropriate task
        
        if let dest = segue.destination as? ClinicalRatingViewController {
            // what to do here?
        }
    }
}
