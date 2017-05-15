//
//  Session.swift
//  Timer
//
//  Created by Soren Nelson on 5/13/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

struct Session {

    var startTime: Date
    var totalLength: TimeInterval?
    
    init(startTime: Date) {
        self.startTime = startTime
    }


}
