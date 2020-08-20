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
    @IBOutlet var buttonStackView: UIStackView!
    
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var currentButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskDetails()
        configureButtons()
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        // goal: download all data from the firebase backend and save it as a JSON/CSV
        
        // use button tags to differentate the buttons from each other
        switch sender.tag {
        case 0:
            print("rotation")
        case 1:
            print("finger tap 1")
        case 2:
            print("finger tap 2")
        default:
            break
        }
        
        // present loading state, set curent button to the sender
        currentButton = sender
        startLoading()
        
        model.delegate = self
        model.readAllData()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToNewTestFromQuestionnaire", sender: self)
    }
    
    private func configureTaskDetails() {
        taskNumberLabel.text = "\(viewModel.taskNumber)"
        taskNumberLabel.textColor = lightBlueColor
        taskNumberOuterView.backgroundColor = .clear
        taskNumberOuterView.layer.cornerRadius = 30
        taskNumberOuterView.layer.masksToBounds = true
        taskNumberOuterView.layer.borderWidth = 3
        taskNumberOuterView.layer.borderColor = lightBlueColor.cgColor
        
    }
    
    private func configureButtons() {
        for subview in buttonStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.layer.masksToBounds = true
                button.layer.cornerRadius = 10
            }
        }
        
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 10
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
        guard let downloadButton = currentButton else { return }
        
        let frame = downloadButton.frame
        
        loadingIndicator = UIActivityIndicatorView(frame: frame)
        loadingIndicator.startAnimating()
        
        loadingIndicator.color = .white
        loadingIndicator.style = .large
        
        loadingIndicator.backgroundColor = lightBlueColor
        loadingIndicator.layer.masksToBounds = true
        loadingIndicator.layer.cornerRadius = 10
        
        downloadButton.isEnabled = false
        UIView.animate(withDuration: 0.4) {
            downloadButton.alpha = 0
        }
        view.addSubview(loadingIndicator)
    }
    
    func stopLoading() {
        guard let downloadButton = currentButton else { return }
        
        downloadButton.isEnabled = true
        UIView.animate(withDuration: 0.4) {
            self.loadingIndicator.alpha = 0
            downloadButton.alpha = 1
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
