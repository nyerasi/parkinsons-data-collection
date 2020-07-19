//
//  FirebaseModel.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/18/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import Foundation
import Firebase

// is this import needed?
import FirebaseFirestoreSwift

protocol FirebaseDataStorage {
    // what do we need here?
}
class FirebaseModel: FirebaseDataStorage {
    
    let db = Firestore.firestore()
    
    // should these functions include completion handlers?
    // these two functions are the same, cannot use RatedTest type
    func writeMovementTaskData(test: MotionTest) {
        print("writing movement task data")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(test)
            try db.collection(test.variant).addDocument(from: test) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("successfully uploaded movement task data")
                }
            }
            
            print(String(data: data, encoding: .utf8)!)
            // inform of submitted data
        } catch {
            print(error)
            // inform of unsubmitted data
        }
    }
    
    func writeFingerTapTaskData(test: FingerTapTest) {
        print("writing finger tap test data")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(test)
            try db.collection(test.variant).addDocument(from: test) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("successfully uploaded finger tap task data")
                }
            }
            
            print(String(data: data, encoding: .utf8)!)
            // inform of submitted data
        } catch {
            print(error)
            // inform of unsubmitted data
        }
    }
    
}

let model = FirebaseModel()
