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
    var timer = Timer()
    
    // CM manager object & queue — should we be using current or main?
    var motion = CMMotionManager()
    var queue = OperationQueue.main
    
    // diff: accelerometer data
    var motionActivityManager: CMMotionActivityManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureTaskDetails()
    }
    
    /*
    func configureMotionManager() {
        // get device processed accelerometer and gyroscope data
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates(to: .main, withHandler: { (data, error) in
            if let error = error {
                let alertAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                self.presentAlert("Something went wrong","\(error.localizedDescription)", alertAction )
            }
        })
    }
 */
    
    func startQueuedUpdates() {
        // https://developer.apple.com/documentation/coremotion/getting_processed_device-motion_data?language=objc
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                                 to: self.queue, withHandler: { (data, error) in
                                                    // Make sure the data is valid before accessing it.
                                                    if let validData = data {
                                                        // Get the attitude relative to the magnetic north reference frame.
                                                        let roll = validData.attitude.roll
                                                        let pitch = validData.attitude.pitch
                                                        let yaw = validData.attitude.yaw
                                                        
                                                        // Use the motion data in your app.
                                                        let transform = CATransform3D(m11: <#T##CGFloat#>, m12: <#T##CGFloat#>, m13: <#T##CGFloat#>, m14: <#T##CGFloat#>, m21: <#T##CGFloat#>, m22: <#T##CGFloat#>, m23: <#T##CGFloat#>, m24: <#T##CGFloat#>, m31: <#T##CGFloat#>, m32: <#T##CGFloat#>, m33: <#T##CGFloat#>, m34: <#T##CGFloat#>, m41: <#T##CGFloat#>, m42: <#T##CGFloat#>, m43: <#T##CGFloat#>, m44: <#T##CGFloat#>)
                                                    }
            })
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if let viewModel = viewModel {
            self.count = viewModel.taskDuration
        }
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
            
            // present alert, present navigation
            let alertAction = UIAlertAction(title: "Rate this task", style: .default) { [weak self] (action) in
                self?.performSegue(withIdentifier: "toRating", sender: self)
            }
            presentAlert("Great work!", "You've completed this task", alertAction)
        } else if count <= 10 {
            timeLabel.text = "00:0\(count)"
        } else {
            timeLabel.text = "00:\(count)"
        }
    }
    
    func presentAlert(_ title: String, _ message: String, _ action: UIAlertAction) {
        // calculate score and accuracy
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        
        // default action (to rate view controller)
        /*
         let rateAction = UIAlertAction(title: "Rate this task", style: .default) { [weak self] (action) in
         // segue to rating screen
         self?.performSegue(withIdentifier: "toRating", sender: self)
         }
         */
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // do something
    }
    
    @IBAction func unwindFromRest( _ seg: UIStoryboardSegue) {
        // from rest view controller after rating
    }
    
}


