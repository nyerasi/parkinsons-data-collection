//
//  NewExamViewController.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/17/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import UIKit

class NewExamViewController: UIViewController {
    
    @IBOutlet var newExamButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureButton()
        // Do any additional setup after loading the view.
    }
    
    private func configureButton() {
        newExamButton.layer.masksToBounds = true
        newExamButton.layer.cornerRadius = 10
    }
    
    @IBAction func unwindToNewTestFromQuestionnaire( _ seg: UIStoryboardSegue) {
        
        // from questionnaire view controller after rating
        
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
