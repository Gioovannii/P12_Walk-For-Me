//
//  LocationStorage.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/23.
//

import Foundation
import CoreLocation

class LocationStorage {
    static let shared = LocationStorage()
    
    private (set) var locations: [Location]
    private let fileManager: FileManager
    private let documentsURL: URL
    
    init() {
        let fileManager = FileManager.default
        documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        self.fileManager = fileManager
        self.locations = []
    }
}
