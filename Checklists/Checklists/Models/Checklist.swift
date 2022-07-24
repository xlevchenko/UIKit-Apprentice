//
//  Checklist.swift
//  Checklists
//
//  Created by Olexsii Levchenko on 7/19/22.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    
    func countUnchekedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
             count += 1
        }
        return count
    }
}
