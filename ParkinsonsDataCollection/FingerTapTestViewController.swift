//
//  FingerTapTestViewController.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/5/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import UIKit

class FingerTapTestViewController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
    
    var viewModel: TaskViewModel?
    
    var count: Int = 10
    var timer: Timer?
    var buttonTaps = [Int: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func targetTapped(_ sender: UIButton) {
        // buttonTaps [button tag (1 - 5): number of taps]
        
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
    }
    
    @objc private func updateStopwatch() {
        count -= 1
        if count  <= 0, var timer = timer {
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
