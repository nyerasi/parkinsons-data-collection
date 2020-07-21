//
//  ClinicalRatingViewController.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/5/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import UIKit

class ClinicalRatingViewController: UIViewController {
    
    @IBOutlet var taskNumberOuterView: UIView!
    @IBOutlet var taskNumberLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var notesTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var radioButtonStackView: UIStackView!
    
    var activeTextField: UITextField?
    
    var motionData: [MotionTaskData]?
    var fingerTapData: [FingerTapData]?
    
    // for radio button rating system
    var currentlySelectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTaskDetails()
        configureButton()
        configureTextField()
        configureRadioButtons()
        
//        navigationItem.hidesBackButton = true
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let alertAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)

        // check rating is not empty
        guard let score = currentlySelectedButton?.tag else {
            presentAlert("Whoops!", "Please rate the task before continuing", alertAction)
            return
        }
        
        // check name field is not empty
        guard let name = nameTextField.text, name.count > 0 else {
            presentAlert("Whoops!", "Please type in the rater's name before continuing", alertAction)
            return
        }
        finalizeRating(rating: score, rater: name)
        performSegue(withIdentifier: "toRest", sender: self)
    }
    
    func finalizeRating(rating: Int, rater: String) {
        // use view model to track activity
        let notes = notesTextField.text ?? ""
        if let motionData = motionData {
            // segued from Pronation Supination
            let finishedMotionTest = MotionTest(duration: viewModel.taskDuration, variant: viewModel.taskName, rating: rating, rater: rater, data: motionData, notes: notes)
            
            model.writeMovementTaskData(test: finishedMotionTest)
            
        } else if let fingerTapData = fingerTapData {
            // segued from Finger Tap (1 or 2 target)
            let finishedFingerTapTest = FingerTapTest(duration: viewModel.taskDuration, variant: viewModel.taskName, rating: rating, rater: rater, data: fingerTapData, notes: notes)
            
            model.writeFingerTapTaskData(test: finishedFingerTapTest)
            
        }
    }
    
    @IBAction func radioButtonTapped(_ sender: UIButton) {
        // GOAL: only one button should be selected at a time
        if let lastSelected = currentlySelectedButton, lastSelected != sender {
            deselectRadioButton(lastSelected)
        }
        selectRadioButton(sender)
        currentlySelectedButton = sender
    }
    
    func configureTextField() {
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // add delegate to TextField
        nameTextField.delegate = self
    }
    
    func selectRadioButton(_ button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height / 2
        UIView.animate(withDuration: 0.2) {
            button.layer.borderColor = darkBlueColor.cgColor
            button.backgroundColor = darkBlueColor
        }
    }
    
    func deselectRadioButton(_ button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.borderWidth = 2
        UIView.animate(withDuration: 0.2) {
            button.layer.borderColor = darkBlueColor.cgColor
            button.backgroundColor = .white
        }
    }
    
    func configureRadioButtons() {
        for subview in radioButtonStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                deselectRadioButton(button)
            }
        }
    }
    
    func presentAlert(_ title: String, _ message: String, _ action: UIAlertAction) {
        // calculate score and accuracy
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        
        alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        var shouldMoveViewUp = false
        
        // if active text field is not nil
        if let activeTextField = activeTextField {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    private func configureTaskDetails() {
        taskNumberLabel.text = "\(viewModel.taskNumber)"
        subtitleLabel.text = "\(viewModel.taskName)"
        taskNumberLabel.textColor = lightBlueColor
        taskNumberOuterView.backgroundColor = .clear
        taskNumberOuterView.layer.cornerRadius = 30
        taskNumberOuterView.layer.masksToBounds = true
        taskNumberOuterView.layer.borderWidth = 3
        taskNumberOuterView.layer.borderColor = lightBlueColor.cgColor
    }
    
    private func configureButton() {
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 10
    }
    
    // for finger tap — ask about open/close hands, fingers
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue to appropriate task
        if let dest = segue.destination as? RestViewController {
            // what should we configure here?
        }
        // where else could this segue to?
    }
    
}

extension ClinicalRatingViewController: UITextFieldDelegate {
    // when user select a textfield, this method will be called
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
    }
    
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.activeTextField = nil
        return false
    }
    
}
