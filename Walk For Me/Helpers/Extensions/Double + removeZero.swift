//
//  Double + removeZero.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/30.
//

import Foundation

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
