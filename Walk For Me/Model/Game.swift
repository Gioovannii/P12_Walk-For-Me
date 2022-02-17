//
//  Game.swift
//  Walk_For_Me
//
//  Created by Giovanni Gaffé on 2021/3/2.
//

import Foundation

/// Data to store all Games information
struct Game {
    var vegetableChoice = [Constant.wheat, Constant.potatoe, Constant.tomatoe]
    var vegetableChoiceMoney = [ Constant.wheat + " 10💰 ", Constant.potatoe + " 20💰",  Constant.tomatoe + " 30💰"]
    var currentValue = ""
    var gardenImages = [String]()
    var gardenImagesTime = [String]()
    var gardenImagesCount = 0
    var exp = 0
    
}
