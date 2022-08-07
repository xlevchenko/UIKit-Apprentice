//
//   Functions.swift
//  MyLocations
//
//  Created by Olexsii Levchenko on 8/6/22.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}


let applicationDocumentsDirectory: URL = {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
}()


let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
print("*** Fatal error: \(error)")
NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
}
