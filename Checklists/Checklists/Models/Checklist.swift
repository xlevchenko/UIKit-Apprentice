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
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
