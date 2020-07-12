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
    
    var viewModel: TaskViewModel?
    
    var count: Int = 10
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startStopwatch()
        // Do any additional setup after loading the view.
    }
    
    func startStopwatch() {
        /*
         if let viewModel = viewModel {
         self.count = viewModel.taskDuration
         }
         */
        self.count = 30
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
            
            // present alert/segue to task overview/other side
        } else if count <= 10 {
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
    
}
