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
    @Persisted var postedDate: Date
    @Persisted var weight: String?
    @Persisted var muscle: String?
    @Persisted var fat: String?
}

extension MyInfo {
    
    static func addMyInfo(_ info: MyInfo) {
        do {
            let realm = try Realm()
            try realm.write{
                realm.add(info)
            }
        } catch {
            print("Error func addMyInfo \(error)")
        }
    }
    
    static func getAllMyInfo() -> Results<MyInfo>? {
        do {
            let realm = try Realm()
            return realm.objects(MyInfo.self)
        } catch {
            print("Error func getAllMyInfo \(error)")
        }
        
        return nil
    }
    
    static func getMyInfo(for date: Date) -> MyInfo? {
        do {
            let realm = try Realm()
            
            let calendar = Calendar.current
            let startDate = calendar.startOfDay(for: date)
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
            
            let myInfo = realm.objects(MyInfo.self).filter("postedDate >= %@ AND postedDate < %@", startDate, endDate)
            return myInfo.first
            
        } catch {
            print("Realm getMyInfo(for date: Date) \(error)")
        }
        
        return nil
    }


    static func updateMyInfo(_ info: MyInfo, newInfo: MyInfo) {
        do {
            let realm = try Realm()
            try realm.write {
                info.weight = newInfo.weight
                info.muscle = newInfo.muscle
                info.fat = newInfo.fat
            }
        } catch {
            print("Error func updateMyInfo \(error)")
        }
    }

    static func deleteMyInfo(_ info: MyInfo) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(info)
            }
        } catch {
            print("Error func deleteMyInfo \(error)")
        }
    }
}

