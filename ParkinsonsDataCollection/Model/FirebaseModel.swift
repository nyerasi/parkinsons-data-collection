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

protocol FirebaseDataStorageDelegate {
    // what do we need here?
    func readDataToJSON(url: URL)
    func finishedWritingData()
}

class FirebaseModel {
    
    let db = Firestore.firestore()
    
    // for use in reading data to JSON
    var delegate: FirebaseDataStorageDelegate?
    
    // for saving to file
    var allTestData = ""
    
    // should these functions include completion handlers?
    // these two functions are the same but we cannot use RatedTest type
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
    
    func readMotionTests() {
        var tests = [MotionTest]()
        db.collection("Pronation-Supination").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            tests = documents.compactMap { (queryDocumentSnapshot) -> MotionTest? in
                return try? queryDocumentSnapshot.data(as: MotionTest.self)
            }
            
            // now encode test data into JSON — this is such a pain
            let encoder = JSONEncoder()
            let encodedData = try? encoder.encode(tests)
            // unwrapping encoded data and casting to String with formatting (what is this doing to the dates?)
            guard let data = encodedData, let stringRepresentation = String(data: data, encoding: .utf8) else { return }
            
            self.allTestData += "Pronation-Supination"
            self.allTestData += "/n"
            
            self.allTestData += stringRepresentation
        }
    }
    
    func readAllData() {
        
        /*
         the smart approach is to use Promises/chain asynch operations using OperationQueue
         maybe something like
         let workItem = DispatchWorkItem() {
             self.readFingerTapTestsOneTarget()
             self.readFingerTapTestsTwoTargets()
             self.readMotionTests()
         }
         
         this following code is awful, I'm sorry
         */
        
        // supination pronation
        var tests = [MotionTest]()
        db.collection("Pronation-Supination").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            print("\(documents.count) pronation tests found")
            tests = documents.compactMap { (queryDocumentSnapshot) -> MotionTest? in
                return try? queryDocumentSnapshot.data(as: MotionTest.self)
            }
            
            // now encode test data into JSON — this is such a pain
            let encoder = JSONEncoder()
            let encodedData = try? encoder.encode(tests)
            // unwrapping encoded data and casting to String with formatting (what is this doing to the dates?)
            guard let data = encodedData, let stringRepresentation = String(data: data, encoding: .utf8) else { return }
            
            self.allTestData += "Pronation-Supination"
            self.allTestData += "/n"
            
            self.allTestData += stringRepresentation
            
            // this is hideous, I know
        
            // one target
            var tapTests = [FingerTapTest]()
            self.db.collection("Finger Tap: One Target").getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }
                print("\(documents.count) one target finger tap tests found")
                tapTests = documents.compactMap { (queryDocumentSnapshot) -> FingerTapTest? in
                    return try? queryDocumentSnapshot.data(as: FingerTapTest.self)
                }
                
                let encoder = JSONEncoder()
                let encodedData = try? encoder.encode(tapTests)
                guard let data = encodedData, let stringRepresentation = String(data: data, encoding: .utf8) else { return }
                
                self.allTestData += "Finger Tap: One Target"
                self.allTestData += "/n"
                
                self.allTestData += stringRepresentation
                
                // two target
                tapTests = [FingerTapTest]()
                self.db.collection("Finger Tap: Two Targets").getDocuments { (snapshot, error) in
                    guard let documents = snapshot?.documents else { return }
                    print("\(documents.count) two target finger tap tests found")
                    tapTests = documents.compactMap { (queryDocumentSnapshot) -> FingerTapTest? in
                        return try? queryDocumentSnapshot.data(as: FingerTapTest.self)
                    }
                    
                    let encoder = JSONEncoder()
                    let encodedData = try? encoder.encode(tapTests)
                    guard let data = encodedData, let stringRepresentation = String(data: data, encoding: .utf8) else { return }
                    
                    self.allTestData += "Finger Tap: Two Targets"
                    self.allTestData += "/n"
                    
                    self.allTestData += stringRepresentation
                    
                    // okay, now build in support for writing to a URL and sharing that URL with the delegate/View Controller
                    
                    self.saveToFile()
                }
            }
        }
    }
    
    func saveToFile() {
        do {
            let appendingDateDescription = Date().description
            
            let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("allTestData\(appendingDateDescription).json")
            
            try self.allTestData.write(to: fileURL, atomically: true, encoding: .utf8)
                                    
            // call the delegate method and we can see if anything works
            self.delegate?.readDataToJSON(url: fileURL)
        } catch {
            print(error)
        }
    }
    
    
}

let model = FirebaseModel()
