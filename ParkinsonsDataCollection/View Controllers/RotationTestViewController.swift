//
//  RotationTestViewController.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/5/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import UIKit
import CoreMotion
// import CoreML

class RotationTestViewController: UIViewController {

    @IBOutlet var taskNumberLabel: UILabel!
    @IBOutlet var taskNumberOuterView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    var viewModel: TaskViewModel?
    
    var count: Int = 10
    var timer: Timer?
    
    // CM manager objects
    var motionManager: CMMotionActivityManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureTaskDetails()
    }
    
    func configureMotionManager() {
        // what should we be doing here?
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
    }
    
    private func configureTaskDetails() {
        if let viewModel = viewModel {
            taskNumberLabel.text = "\(viewModel.taskNumber)"
        }
        
        taskNumberLabel.textColor = lightBlueColor
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
