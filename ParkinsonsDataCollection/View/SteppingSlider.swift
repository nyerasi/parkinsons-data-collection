//
//  SteppingSlider.swift
//  ParkinsonsDataCollection
//
//  Created by Nikhil Yerasi on 7/11/20.
//  Copyright © 2020 nyerasi. All rights reserved.
//

import Foundation
import UIKit

class SteppingSlider: UISlider {
    private let values: [Float]
    private var lastIndex: Int? = nil
    let callback: (Float) -> Void

    init(frame: CGRect, values: [Float], callback: @escaping (_ newValue: Float) -> Void) {
        self.values = values
        self.callback = callback
        super.init(frame: frame)
        self.addTarget(self, action: #selector(handleValueChange(sender:)), for: .valueChanged)

        let steps = values.count - 1
        self.minimumValue = 0
        self.maximumValue = Float(steps)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleValueChange(sender: UISlider) {
        let newIndex = Int(sender.value + 0.5) // round up to next index
        self.setValue(Float(newIndex), animated: false) // snap to increments
        let didChange = lastIndex == nil || newIndex != lastIndex!
        if didChange {
            lastIndex = newIndex
            let actualValue = self.values[newIndex]
            self.callback(actualValue)
        }
    }
}
