//
//  Extensions.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/24/21.
//

import Foundation

extension Double {
    func removeTrailingZeroes() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self))!
    }
}
