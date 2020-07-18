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
    
    func writeMovementTaskData(test: MotionTest) {
        print("writing Movement Test data")
    }
    
    func writeFingerTapTaskData(test: FingerTapTest) {
        print("writing Finger Tap Test data")
    }
    
}

let model = FirebaseModel()
