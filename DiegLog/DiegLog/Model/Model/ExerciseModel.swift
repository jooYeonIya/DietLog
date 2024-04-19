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
    @Persisted var thumbnailURL: String
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
    
    static func getAllExercise(for categoryID: ObjectId) -> Results<Exercise>? {
        let query = NSPredicate(format: "categoryID == %@", categoryID)
        
        do {
            let realm = try Realm()
            return realm.objects(Exercise.self).filter(query)
        } catch {
            print("Error func getAllExercise \(error)")
        }
        
        return nil
    }
    
    static func getAllExercise(with searchWord: String) -> Results<Exercise>? {
        let query = NSPredicate(format: "title CONTAINS[c] %@", searchWord)
        
        do {
            let realm = try Realm()
                return realm.objects(Exercise.self).filter(query)
        } catch {
            print("Error func getAllExercise(for searchWord: String) \(error)")
        }
        
        return nil
    }
    
    static func updateExercise(_ exercise: Exercise, newCategoryID: ObjectId) {
        do {
            let realm = try Realm()
            try realm.write {
                exercise.categoryID = newCategoryID
            }
        } catch {
            print("Error updateExercise(_ exercise: Exercise, newCategoryID: ObjectId) \(error)")
        }
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
