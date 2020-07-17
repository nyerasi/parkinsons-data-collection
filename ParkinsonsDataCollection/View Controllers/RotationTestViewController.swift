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
    
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var yawLabel: UILabel!
    @IBOutlet var pitchLabel: UILabel!
    @IBOutlet var rollLabel: UILabel!
    
    var count: Int = 10
    var timer = Timer()
    
    // CM manager object & queue — should we be using current or main?
    var motion = CMMotionManager()
    var queue = OperationQueue.main
    var motionData = [MotionTaskData]()
    
    // file for opening and writing data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTaskDetails()
        configureButton()
        
        navigationItem.hidesBackButton = true
    }
    
    func writeCSV() {
        let fileName = "SupinationPronation.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var motionDataText = "Date,UserAccelerationX,UserAccelerationY,UserAccelerationZ,Roll,Pitch,Yaw\n"
        
        // loop through motionDataText
        for motion in motionData {
            let newLine = "\(motion.date),\(motion.userAccelerationX),\(motion.userAccelerationY),\(motion.userAccelerationZ),\(motion.roll),\(motion.pitch),\(motion.yaw)\n"
            motionDataText.append(newLine)
        }
        
        do {
            try motionDataText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // present alert (reset state of view controller activity?)
            let retryAlertAction = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
            presentAlert("Something went wrong!", error.localizedDescription, [retryAlertAction])
        }
        
        // how should we organize this?
        // present alert, present navigation, incorporate sharing action
        let rateAlertAction = UIAlertAction(title: "Rate this task", style: .default) { [weak self] (action) in
            self?.performSegue(withIdentifier: "toRating", sender: self)
        }
        
        presentAlert("Great work!", "You've completed this task", [rateAlertAction])
    }
    
    func startQueuedUpdates() {
        // https://developer.apple.com/documentation/coremotion/getting_processed_device-motion_data?language=objc
        let updateFrequency = 1.0 / 60.0
        let motionHandler: CMDeviceMotionHandler = { [weak self] (motion, error) in
            if let validData = motion {
                let newData = MotionTaskData(date: Date(),
                                             userAccelerationX: validData.userAcceleration.x,
                                             userAccelerationY: validData.userAcceleration.y,
                                             userAccelerationZ: validData.userAcceleration.z,
                                             roll: validData.attitude.roll,
                                             pitch: validData.attitude.pitch, yaw: validData.attitude.yaw)
                
                self?.motionData.append(newData)
                
                // update UI to reflect rotation motion data
                self?.rollLabel.text = "Roll: \(newData.roll)"
                self?.pitchLabel.text = "Pitch: \(newData.pitch)"
                self?.yawLabel.text = "Yaw: \(newData.yaw)"
                
                var transform: CATransform3D
                transform = CATransform3DMakeRotation(CGFloat(newData.pitch), 1, 0, 0) // X
                transform = CATransform3DRotate(transform, CGFloat(newData.roll), 0, 1, 0) // Y
                transform = CATransform3DRotate(transform, CGFloat(newData.yaw), 0, 0, 1) // Z
                
                self?.arrowImageView.layer.transform = transform
            }
        }
        
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = updateFrequency
            self.motion.showsDeviceMovementDisplay = true
            // test different attitude reference planes (magnetic north/true north/arbitrary)
            self.motion.startDeviceMotionUpdates(using: .xArbitraryZVertical,
                                                 to: self.queue, withHandler: motionHandler)
        }
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
        
        startQueuedUpdates()
    }
    
    func stopActivity() {
        // end device motion updates, invalidate timer, present alert
        motion.stopDeviceMotionUpdates()
        timer.invalidate()
        timeLabel.text = "00:00"
        
        // write data to CSV
        writeCSV()
    }
    
    @objc private func updateStopwatch() {
        count -= 1
        // format counter for label
        if count <= 0 {
            stopActivity()
        } else if count < 10 {
            timeLabel.text = "00:0\(count)"
        } else {
            timeLabel.text = "00:\(count)"
        }
    }
    
    func presentAlert(_ title: String, _ message: String, _ actions: [UIAlertAction]) {
        // calculate score and accuracy
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        
        for action in actions {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // do something
    }
}
