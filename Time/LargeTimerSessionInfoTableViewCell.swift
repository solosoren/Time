//
//  LargeTimerSessionInfoTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 9/3/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class LargeTimerSessionInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var numberOfSessionsButton: UIButton!
    var tableview: LargeTimerViewController?

    func setUpCell() {
        let seshes = tableview?.project?.activeTimer?.sessions.count ?? 1
        numberOfSessionsButton.setTitle("\(seshes)", for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
