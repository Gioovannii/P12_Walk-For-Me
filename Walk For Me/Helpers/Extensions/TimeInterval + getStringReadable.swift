//
//  TimeInterval + getStringReadable.swift
//  Walk_For_Me
//
//  Created by Giovanni Gaffé on 2021/6/15.
//

import Foundation

extension TimeInterval {

//        func stringFromTimeInterval() -> String {
    func intFromTimeInterval() -> Int {

            let time = NSInteger(self)
            let minutes = (time / 60) % 60

//            return String(format: "%0.2d ",minutes)
            return minutes
        }
    }
