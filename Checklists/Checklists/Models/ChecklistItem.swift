//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Olexsii Levchenko on 7/5/22.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        super.init()
    }
}
