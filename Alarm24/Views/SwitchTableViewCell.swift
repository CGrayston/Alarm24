//
//  SwitchTableViewCell.swift
//  Alarm24
//
//  Created by Chris Grayston on 1/28/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

// Step 1 of 5 for custom delgates
protocol SwitchTableViewCellDelegate: class {
    func switchValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
}

class SwitchTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // Similar to landing pad
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    // Step 2 of 5 for custom delegate
    weak var delegate: SwitchTableViewCellDelegate?
    

    
    
    // MARK: - Life Cycle  Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Step 3 of 5 for custom delegates
    @IBAction func settingSwitchValueChanged(_ sender: UISwitch) {
        delegate?.switchValueChanged(self, selected: alarmSwitch.isOn) // TODO make sure it is alram switch
    }
    
    func updateViews() {
        // Update labels to the time and name of the alarm
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        
        
        //Updates the alarmSwitch.isOn property so that the switch reflects the proper alarm enabled state.
        alarmSwitch.isOn = alarm.enabled
    }
    

    // MARK: - Actions
    @IBAction func switchValueChanged(_ sender: UISwitch) {
       // delegate?.switchValueChanged(self, selected: alarmSwitch.isOn)
        
        guard let alarm = alarm else { return }
        
        alarm.enabled = !alarm.enabled
        AlarmController.shared.saveToPersistantStore()
    }
    

}
