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

extension ExerciseCategory {
    
    static func addExerciseCategory(_ category: ExerciseCategory) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error func addExerciseCategory \(error)")
        }
    }

    static func getAllExerciseCategories() -> Results<ExerciseCategory>? {
        do {
            let realm = try Realm()
            return realm.objects(ExerciseCategory.self)
        } catch {
            print("Error func getAllExerciseCategories \(error)")
        }
        
        return nil
    }

    static func updateExerciseCategory(_ category: ExerciseCategory, newTitle: String){
        do {
            let realm = try Realm()
            try realm.write {
                category.title = newTitle
            }
        } catch {
            print("Error func updateExerciseCategory \(error)")
        }
    }

    static func deleteExerciseCategory(_ category: ExerciseCategory) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error func deleteExerciseCategory \(error)")
        }
    }
}
