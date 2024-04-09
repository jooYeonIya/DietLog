//
//  MealModel.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/09.
//

import Foundation
import RealmSwift

class Meal: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var postedDate: Date
    @Persisted var image: Data?
    @Persisted var memo: String?
}
