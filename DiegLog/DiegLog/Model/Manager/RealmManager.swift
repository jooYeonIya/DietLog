//
//  RealmManager.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/19.
//

import Foundation
import RealmSwift

class RealmManager {
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Error RealmManager \(error)")
        }
    }
}
