//
//  String + AddText.swift
//  MyLocations
//
//  Created by Olexsii Levchenko on 8/25/22.
//

import UIKit

extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
