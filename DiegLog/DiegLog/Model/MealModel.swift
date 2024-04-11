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
    @Persisted var imageName: String?
    @Persisted var memo: String?
}

extension Meal {
    
    static func addMeal(_ meal: Meal) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(meal)
            }
        } catch {
            print("Error func addMeal \(error)")
        }
    }

    static func getAllMeals() -> Results<Meal>? {
        do {
            let realm = try Realm()
            return realm.objects(Meal.self)
        } catch {
            print("Error func getMeal \(error)")
        }
        
        return nil
    }
    
    static func getMeal(for id: ObjectId) -> Meal? {
        let query = NSPredicate(format: "id == %@", id)
        
        do {
            let realm = try Realm()
            return realm.objects(Meal.self).filter(query).first
        } catch {
            print("Error func getMeal(for id: ObjectId) \(error)")
            return nil
        }
    }

    static func updateMeal(_ meal: Meal, newMeal: Meal){
        do {
            let realm = try Realm()
            try realm.write {
                meal.postedDate = newMeal.postedDate
                meal.imageName = newMeal.imageName
                meal.memo = newMeal.memo
            }
        } catch {
            print("Error func updateMeal \(error)")
        }
    }

    static func deleteMeal(_ meal: Meal) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(meal)
            }
        } catch {
            print("Error func deleteMeal \(error)")
        }
    }
}
