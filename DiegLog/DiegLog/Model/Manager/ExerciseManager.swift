//
//  ExerciseManager.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/19.
//

import Foundation
import RealmSwift

class ExerciseManager: RealmManager {
    
    static let shared = ExerciseManager()
    
    func addExercise(_ exercise: Exercise) {
        do {
            try realm.write {
                realm.add(exercise)
            }
        } catch {
            print("Error func addExercise \(error)")
        }
    }
    
    func getAllExercise() -> Results<Exercise>? {
        return realm.objects(Exercise.self)
    }
    
    func getAllExercise(for categoryID: ObjectId) -> Results<Exercise>? {
        let query = NSPredicate(format: "categoryID == %@", categoryID)
        return realm.objects(Exercise.self).filter(query)
    }
    
    func getAllExercise(with searchWord: String) -> Results<Exercise>? {
        let query = NSPredicate(format: "title CONTAINS[c] %@", searchWord)
        return realm.objects(Exercise.self).filter(query)
    }
    
    func updateExercise(_ exercise: Exercise, newCategoryID: ObjectId) {
        do {
            try realm.write {
                exercise.categoryID = newCategoryID
            }
        } catch {
            print("Error updateExercise(_ exercise: Exercise, newCategoryID: ObjectId) \(error)")
        }
    }
    
    func deleteExercise(_ exercise: Exercise) {
        do {
            try realm.write {
                realm.delete(exercise)
            }
        } catch {
            print("Error func deleteExercise \(error)")
        }
    }
}
