//
//  MealModel.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/09.
//

import Foundation
import RealmSwift
import UIKit


class Meal: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var postedDate: Date
    @Persisted var folderName: String?
    @Persisted var imageName: String?
    @Persisted var memo: String?
    
    var imagePath: String? {
         guard let folder = folderName, let image = imageName else { return nil }
         return "\(folder)/\(image).png"
     }
}
