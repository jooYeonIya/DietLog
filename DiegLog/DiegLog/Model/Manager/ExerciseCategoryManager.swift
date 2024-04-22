//
//  ExerciseCatergoryManager.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/19.
//

import Foundation
import RealmSwift

class ExerciseCatergoryManager: RealmManager {
    
    static let shared = ExerciseCatergoryManager()
    
    func addExerciseCategory(_ category: ExerciseCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error func addExerciseCategory \(error)")
        }
    }

    func getAllExerciseCategories() -> Results<ExerciseCategory>? {
        return realm.objects(ExerciseCategory.self)
    }
    
    func getExerciseCategory(at id: ObjectId) -> ExerciseCategory? {
        let query = NSPredicate(format: "id == %@", id)
        return realm.objects(ExerciseCategory.self).filter(query).first
    }

    func updateExerciseCategory(_ category: ExerciseCategory, newTitle: String){
        do {
            try realm.write {
                category.title = newTitle
            }
        } catch {
            print("Error func updateExerciseCategory \(error)")
        }
    }

    func deleteExerciseCategory(_ category: ExerciseCategory) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error func deleteExerciseCategory \(error)")
        }
    }
}
