//
//  ExerciseCategoryModel.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/09.
//

import Foundation
import RealmSwift

class ExerciseCategory: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
}
