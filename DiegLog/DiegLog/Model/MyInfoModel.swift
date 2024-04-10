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
    @Persisted var weight: Int?
    @Persisted var muscle: Int?
    @Persisted var fat: Int?
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

