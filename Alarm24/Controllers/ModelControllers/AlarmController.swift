//
//  AlarmController.swift
//  Alarm24
//
//  Created by Chris Grayston on 1/28/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        // Create an instance of UNMutableNotificationContent
        let notificationContent = UNMutableNotificationContent()
        
        // Give that instance a title and body
        notificationContent.title = "\(alarm.name) Alarm"
        notificationContent.body = "Time to get up it is \(alarm.fireTimeAsString)"
        notificationContent.sound = UNNotificationSound.default
        
        //guard let timeOfAlarm = alarm else { return }
        //TODO - Schedule and Cancel Local Notifications using a Custom Protocol and Extension Step 4
        
        // Create date for it to fire // ?? TODO ??Use the current property of the Calendar class to call a method which returns dateComponents from a date.
        let fireDate = alarm.fireDate
        
        // Date Component
        let dateComponent = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        
        // Create instance of UNCalendarNotificationTrigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        // Initilize request
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    
}

class AlarmController: AlarmScheduler {
    
    // Shared instance
    static let shared = AlarmController()
    
    
    // Source of truth
    var alarms: [Alarm] = []
    
    
    
    // MARK: - CRUD
    
    // Create
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarm.enabled = enabled
        AlarmController.shared.alarms.append(alarm)
        scheduleUserNotifications(for: alarm)
        
        saveToPersistantStore()
        
    }
    
    // Update
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        
        scheduleUserNotifications(for: alarm)
        saveToPersistantStore()
    }
    
    // Delete
    func delete(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else { return }
        self.cancelUserNotifications(for: alarm)
        alarms.remove(at: index)
        
        saveToPersistantStore()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        
        saveToPersistantStore()
    }
    
    // Get URL
    func fileURL() -> URL {
        
        // Will give you a file path to users documents
        // user domain mask is users home directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentDirectory = paths[0]
        
        // Set as name of your project // where we are going to save stuff to
        let alarmLocation = "alarm.json"
        
        // Appendign path comp adds slash and playlistLocation
        let url = documentDirectory.appendingPathComponent(alarmLocation)
        print(url.absoluteString)
        
        return url
    }
    
    // Save to file location we established
    func saveToPersistantStore() {
        
        // Create instance of JSONEncoder // Encode returns data
        let jsonEncoder = JSONEncoder()
        
        do {
            // Encode our data so that is can be saved // get the playlists as data
            let alarmsAsData = try jsonEncoder.encode(AlarmController.shared.alarms)
            
            
            // Save the data to our user's hard drive
            try alarmsAsData.write(to: fileURL())
            
        } catch {
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() {
        
        // Create instance of JSONEncoder
        let jsonDecoder = JSONDecoder()
        
        do {
            // Get our data from our app's file path
            let data = try Data(contentsOf: fileURL())
            
            // Tell the decoder the type of thing we are going to be loading
            // Decode the data into Playlists objects
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: data)
            
            // Set our source of truth
            self.alarms = decodedAlarms
        } catch {
            print("There was an error loading from the persistent store: \(error.localizedDescription)")
        }
    }
    
}
