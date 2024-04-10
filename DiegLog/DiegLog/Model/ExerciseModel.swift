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

extension Exercise {
    static func addExercise(_ exercise: Exercise) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(exercise)
            }
        } catch {
            print("Error func addExercise \(error)")
        }
    }
    
    static func getAllExercise() -> Results<Exercise>? {
        do {
            let realm = try Realm()
            return realm.objects(Exercise.self)
        } catch {
            print("Error func getAllExercise \(error)")
        }
        
        return nil
    }
    
    static func deleteExercise(_ exercise: Exercise) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(exercise)
            }
        } catch {
            print("Error func deleteExercise \(error)")
        }
    }
}
