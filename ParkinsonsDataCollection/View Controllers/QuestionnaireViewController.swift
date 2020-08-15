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
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var downloadButton: UIButton!
    
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskDetails()
        configureButtons()
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        // goal: download all data from the firebase backend and save it as a JSON/CSV

        // present loading state
        startLoading()
        
        model.delegate = self
        model.readAllData()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToNewTestFromQuestionnaire", sender: self)
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
    
    private func configureButtons() {
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 10
        
        downloadButton.layer.masksToBounds = true
        downloadButton.layer.cornerRadius = 10
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

// for loading indicator
extension QuestionnaireViewController {
    func startLoading() {
//        loadingIndicator = UIActivityIndicatorView(frame: downloadButton.frame)
        let frame = downloadButton.frame
        
        loadingIndicator = UIActivityIndicatorView(frame: frame)
        loadingIndicator.startAnimating()
        
        loadingIndicator.color = .white
        loadingIndicator.backgroundColor = lightBlueColor
        loadingIndicator.layer.masksToBounds = true
        loadingIndicator.layer.cornerRadius = 10
        
        downloadButton.isEnabled = false
        UIView.animate(withDuration: 0.4) {
            self.downloadButton.alpha = 0
        }
        view.addSubview(loadingIndicator)
    }
    
    func stopLoading() {
        downloadButton.isEnabled = true
        UIView.animate(withDuration: 0.4) {
            self.loadingIndicator.alpha = 0
            self.downloadButton.alpha = 1
        }
        
        self.loadingIndicator.removeFromSuperview()
    }
    
    
}

extension QuestionnaireViewController: FirebaseDataStorageDelegate {

    func finishedWritingData() {
        print("wrote data")
    }
    
    func readDataToJSON(url: URL) {
        print("url: \(url)")
        // https://stackoverflow.com/questions/50703353/trying-to-share-a-json-string-in-a-file-with-an-activity-view-controller
        DispatchQueue.main.async {
            // remove loading indicator
            self.stopLoading()
            
            do {
                let _ = try Data(contentsOf: url)
                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
    }
}
