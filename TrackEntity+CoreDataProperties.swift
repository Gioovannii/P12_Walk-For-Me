//
//  TrackEntity+CoreDataProperties.swift
//  Walk_For_Me
//
//  Created by Giovanni Gaffé on 2022/2/10.
//
//

import Foundation
import CoreData
import CoreLocation

extension TrackEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackEntity> {
        return NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var totalPace: String?
    @NSManaged public var locations: [CLLocation]?

}
