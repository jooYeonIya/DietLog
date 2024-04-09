//
//  MyInfoModel.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/09.
//

import Foundation
import RealmSwift

class MyInfo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var createDate: Date
    @Persisted var weight: Int?
    @Persisted var muscle: Int?
    @Persisted var fat: Int?
}
