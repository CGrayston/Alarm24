//
//  AlarmDetailTableViewController.swift
//  Alarm24
//
//  Created by Chris Grayston on 1/28/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var enabledDisabledButton: UIButton!
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    
//    Add a variable named alarmIsOn of type Bool with an initial value of true to the top of your AlarmDetailTableViewController class. *note: Make sure to set the alarmIsOn property equal to the alarm.enabled property in the case that the alarm object exists.
    // TODO? Wire up the alarm detail table view #2
    var alarmIsOn: Bool = true
    
//    init(alarmIsOn: Bool) {
//        if let alarm = alarm {
//            self.alarmIsOn = alarm.enabled
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    
    private func updateViews() {
        // If alarm is not nil
        //if let alarm = alarm {
        
        // Populate the date picker and alarm title text field with the current alarm's date and title.
        guard let alarm = alarm else { return }
        alarmIsOn = alarm.enabled
        alarmDatePicker.date = alarm.fireDate
        alarmNameTextField.text = alarm.name

        setUpAlarmButton()
    }
    
    func setUpAlarmButton() {
        // set the enable button to say "On" if the alarm in self.alarm is enabled and "Off" if it is disabled. You may consider changing background color and font color properties as well to make the difference between the two button states clear.
        if alarmIsOn {
            enabledDisabledButton.titleLabel?.text = "On"
            enabledDisabledButton.backgroundColor = .green
            enabledDisabledButton.titleLabel?.textColor = .white
        }
            // initial alarm property will be nil (when we are creating a new alarm), you will need to use the isAlarmOn property you created earlier to set up the button's UI initially. *note: You must guard against the alarm being nil, or the view controller's view not yet being loaded and properly handle these cases.
        else {
            enabledDisabledButton.titleLabel?.text = "Off"
            enabledDisabledButton.backgroundColor = .red
            enabledDisabledButton.titleLabel?.textColor = .black
        }
    }
    // MARK: - Actions
    @IBAction func enableButtonTapped(_ sender: Any) {
        if let alarm = alarm {
            AlarmController.shared.toggleEnabled(for: alarm)
            alarmIsOn = alarm.enabled
        }else{
            alarmIsOn = !alarmIsOn
        }
        setUpAlarmButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = alarmNameTextField.text else {return}
        guard title != "" else {return}
        
        if let alarm = alarm{
            AlarmController.shared.update(alarm: alarm, fireDate: alarmDatePicker.date, name: title, enabled: alarmIsOn)
        } else{
            AlarmController.shared.addAlarm(fireDate: alarmDatePicker.date, name: title, enabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }

}

