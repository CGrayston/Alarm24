//
//  AlarmListTableViewController.swift
//  Alarm24
//
//  Created by Chris Grayston on 1/28/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

// Step 4 of 5
// Our custom protocol
extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchValueChanged(_ cell: SwitchTableViewCell, selected: Bool) {
        
        guard let alarm = cell.alarm, let alarmIndexPath = tableView.indexPath(for: cell) else { return }
        
        let alarmToSchedule = AlarmController.shared.alarms[alarmIndexPath.row]
        AlarmController.shared.scheduleUserNotifications(for: alarmToSchedule)
        
        tableView.beginUpdates()
        alarm.enabled = selected
        tableView.reloadRows(at: [alarmIndexPath], with: .automatic)
        tableView.endUpdates()
        
        
    }
}

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        AlarmController.shared.loadFromPersistentStore()
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return AlarmController.shared.alarms.count
    }

    // TODO Wire up the Alarm List 4 & 5
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else {
            return UITableViewCell()
        }
        
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell.nameLabel.text = alarm.name
        cell.timeLabel.text = alarm.fireTimeAsString
        cell.alarmSwitch.isOn = alarm.enabled
        
        // AlarmListTableVC set as the delegate Step 5 of 5
        cell.delegate = self
        cell.alarm = alarm

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Switch on editing style
        switch editingStyle {
        // switch when deleted, update that we deleted it and have less rows now
        case .delete:
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Identify
        if segue.identifier == "toAlarmDetailSegue" {
            // Index path
            if let indexPath = tableView.indexPathForSelectedRow {
                // Destination
                if let destinationVC = segue.destination as? AlarmDetailTableViewController {
                    
                    // Object to send
                    let entryToSend = AlarmController.shared.alarms[indexPath.row]
                    
                    // Reciever Object: What object will catch this data
                    destinationVC.alarm = entryToSend
                }
            }
        }
    }
}



