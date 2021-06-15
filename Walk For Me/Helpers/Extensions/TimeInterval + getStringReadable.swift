//
//  TimeInterval + getStringReadable.swift
//  Walk_For_Me
//
//  Created by Giovanni Gaffé on 2021/6/15.
//

import Foundation

extension TimeInterval {

        func stringFromTimeInterval() -> String {

            let time = NSInteger(self)
            
            let seconds = time % 60
            let minutes = (time / 60) % 60
            let hours = (time / 3600)

            return String(format: "%0.2dh %0.2dm %0.2ds",hours,minutes,seconds)

        }
    }
