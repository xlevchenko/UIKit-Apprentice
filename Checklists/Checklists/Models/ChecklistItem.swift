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
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    func scheduleNotification() {
        if shouldRemind && dueDate > Date() {
            print("We should schedule a notification!")
        }
    }
}
