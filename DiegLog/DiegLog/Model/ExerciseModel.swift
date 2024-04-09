//
//  ExerciseModel.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/09.
//

import Foundation
import RealmSwift

class Exercise: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var URL: String
    @Persisted var thumbnailURL: Data
    @Persisted var categoryID: ObjectId
}
