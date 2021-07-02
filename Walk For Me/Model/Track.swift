//
//  PositionUser.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/30.
//

import Foundation
import CoreLocation


/// Data to set a New Track
struct Track {
    
    var locations: [CLLocation] = []
    var totalPace: Double = 0.0
    var timeStamp: Date = Date()
}
